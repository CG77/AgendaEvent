<?php

namespace Event\AgendaBundle\Controller;

use eZ\Publish\API\Repository\Values\Content\Content;
use eZ\Publish\API\Repository\Values\Content\Query;
use eZ\Publish\API\Repository\Values\Content\Query\Criterion;
use Novactive\eZNovaExtraBundle\Controller\BaseController;
use ezfSolrDocumentFieldBase;
use DateTime;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use eZ\Publish\Core\MVC\Symfony\Security\Authorization\Attribute as AuthorizationAttribute;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Security\Core\Exception\AccessDeniedException;

class AgendaController extends BaseController {

    public function viewLocationAction( $locationId, $viewType, $layout = false, array $params = array() ) {
        $contentService = $this->getRepository()->getContentService();
        $locationService = $this->getRepository()->getLocationService();
        $location = $locationService->loadLocation( $locationId );
        $content = $contentService->loadContentByContentInfo( $location->getContentInfo() );

        $limit = 10;
        $offset = 0;
        $page = 1;
        $latitude = $longitude = "";

        if ( $this->getRequest()->get( "page" ) != "" ) {
            $page = $this->getRequest()->get( "page" );
            $offset = ( $page - 1 ) * $limit;
        }

        $defaultData = array();
        $options = array( 'csrf_protection' => false );

        $aTmpTags = $content->getFieldValue( "tag" )->tags;
        $thematicSearch = array();

        foreach( $aTmpTags as $oTag ) {
            $thematicSearch[$oTag->id] = $oTag->keyword;
            $defaultData["diaryTopic"][] = $oTag->id;
        }

        if ( $this->getRequest()->get( "form" ) ) {
            $aRequestForm             = $this->getRequest()->get( "form" );
            $defaultData["diaryWhere"] = $aRequestForm["diaryWhere"];
            if ( $aRequestForm["diaryWhen"] != "" ) {
                $dateArray = explode('/',$aRequestForm["diaryWhen"]);
                $date = new \DateTime($dateArray[0].'-'.$dateArray[1].'-'.$dateArray[2]);
                $defaultData["diaryWhen"] = $date;
            }
        }

        $form = $this->createFormBuilder( $defaultData, $options )->setMethod( 'GET' )
                     ->add( 'diaryWhere', 'text', array( 'required' => false ) )
                     ->add( 'diaryWhen', 'date', array( 'widget' => 'single_text', 'required' => false ) )
                     ->add( 'diaryTopic', 'choice', array( 'choices'  => $thematicSearch,
                                                           'multiple' => true,
                                                           'expanded' => true,
                                                           'required' => false ) )
            ->getForm();

        if ( isset( $aRequestForm ) ) {
            $form->handleRequest( $this->getRequest() );
            $data = $form->getData();

            if ( $aRequestForm["diaryWhere"] ) {
                $params["diaryWhere"] = $aRequestForm["diaryWhere"];
            }

            if ( $this->getRequest()->get( "latitude" ) != "" && $this->getRequest()->get( "longitude" ) != "" ) {
                $params["sort_by"] = $this->getRequest()->get( "latitude" ) . "," . $this->getRequest()->get( "longitude" );
                $latitude = $this->getRequest()->get( "latitude" );
                $longitude = $this->getRequest()->get( "longitude" );
                unset($params["diaryWhere"]);
            }

            if ( $data['diaryWhen'] != "" ) {

                $oSearchDate = DateTime::createFromFormat( "d/m/Y H:i:s", $data['diaryWhen']->format('d/m/Y') . " 00:00:00" );
                $timestamp = $oSearchDate->getTimestamp();
                $params["diaryWhen"] = $this->getLegacyKernel()->runCallback( function () use ( $timestamp ) {
                    return ezfSolrDocumentFieldBase::convertTimestampToDate( $timestamp );
                });
            }

            $aThematic            = $data['diaryTopic'];
            $params["diaryTopic"] = $aThematic;
        }

        $params["subtree"] = $locationId;
        $params["limit"] = $limit;
        $params["offset"] = $offset;

        $aResultSearch = $this->getResultSearch( $params );
        $nbPage = ceil( $aResultSearch["SearchCount"] / $limit );

        $aMapsInfos = $this->buildMapInfos( $aResultSearch );

        $aGetParams = $this->getRequest()->query->all();
        if ( isset( $aGetParams["page"] ) ) {
            unset( $aGetParams["page"] );
        }

        return $this->render( "EventAgendaBundle:Full:n-2_page_agenda.html.twig", array( "content"     => $content,
                                                                                     "location"    => $location,
                                                                                     "form"        => $form->createView(),
                                                                                     "search"      => $aResultSearch,
                                                                                     'currentPage' => $page,
                                                                                     'param_get'   => http_build_query( $aGetParams ),
                                                                                     "nbPage"      => $nbPage,
                                                                                     "mapsInfo"    => json_encode( $aMapsInfos ),
                                                                                     "latitude"    => $latitude,
                                                                                     "longitude"   => $longitude
        ) );
    }

    public function getResultSearch( $params ) {
        $searchService = $this->get( 'cg_helper.search' );

        // Keyword to search
        $query = "*";

        //Get all elements under NodeID '2'
        $subtree = array( $params["subtree"] );

        // Add filter who apply to search
        $filter = array();

        if ( isset( $params["diaryTopic"] ) ) {
            $filter[] = 'subattr_tag___tag_id____si:(' . implode( " OR ", $params["diaryTopic"] ) . ')';
        }

        if ( isset( $params["diaryWhen"] ) ) {

            $dateBegin = new DateTime($params["diaryWhen"]);
            $filterDate = array();

            $filterDate[] = 'or';

            if($dateBegin->getTimestamp() > time()) {
                $filterDate[] = 'attr_begin_date_dt:[NOW TO ' . $params["diaryWhen"] . ']';
            }
            else {
                $filterDate[] = 'attr_begin_date_dt:['. $params["diaryWhen"] . ' TO NOW]';
            }

            $filterDate[] = 'attr_end_date_dt:[' . $params["diaryWhen"] . ' TO *]';

            $filter[] = $filterDate;
        }

        if ( isset( $params["diaryWhere"] ) ) {
            $filter[] = 'submeta_event_place___city_ms:' . $params["diaryWhere"];
        }

        // Add filter by class_identifier
        $class_id = array( 'event_page' );
        // Add sort
        $sort = array();
        if ( isset( $params["sort_by"] ) ) {
            $sort['geodist( subattr_event_place___geoloc____gpt,' . $params["sort_by"] . ')'] = 'asc';
        }
        $sort["attr_begin_date_dt"] = 'asc';

        // Add limit to return result
        $limit = $params["limit"];

        $offset = $params["offset"];


        $contentResults = $searchService->search( $query, $subtree, $filter, $class_id, $sort, $limit, $offset );

        return array( 'SearchCount'  => $contentResults->getResultTotalCount(),
                      'SearchResult' => $contentResults->getResults() );
    }

    /**
     * @Route("/event/list/", name="_cg_event_list")
     */
    public function manageEventAction() {
        $bShowEdit = $bShowDelete = false;

        if ( !$this->isGranted( new AuthorizationAttribute( 'event', 'list' ) ) ) {
            throw new AccessDeniedException();
        }

        if ( $this->isGranted( new AuthorizationAttribute( 'event', 'edit' ) ) ) {
            $bShowEdit = true;
        }

        if ( $this->isGranted( new AuthorizationAttribute( 'event', 'delete' ) ) ) {
            $bShowDelete = true;
        }

        $searchService = $this->getRepository()->getSearchService();
        $oUser = $this->getRepository()->getCurrentUser();

        $query = new Query();

        $query->criterion = new Criterion\LogicalAnd(
            array(
                new Criterion\ContentTypeIdentifier( "event_page"  ),
                new Criterion\UserMetadata( Criterion\UserMetadata::OWNER, Criterion\Operator::EQ, $oUser->contentInfo->id )
            )
        );

        $aTmpResult = $searchService->findContent( $query );
        $aResult = array();

        foreach ( $aTmpResult->searchHits as $oResult ) {
            $aResult[] = $oResult->valueObject;
        }

        $response = new Response();
        $response->setPrivate();
        $response->setVary( "X-User-Hash" );

        return $this->render( "EventAgendaBundle:Agenda:manage_event.html.twig", array(
            "results" => $aResult,
            "showEdit" => $bShowEdit,
            "showDelete" => $bShowDelete
        ), $response );

    }

    public function showRightBlocAction( $locationId, $page ) {
        $locationService = $this->getRepository()->getLocationService();
        $location = $locationService->loadLocation( $locationId );

        $bShowAdd = false;
        $bShowList = false;
        $bShowAgenda = true;

        if ( $this->isGranted( new AuthorizationAttribute( 'event', 'action' ) ) && ( $page == "homepage" || $page == "list" ) ) {
            $bShowAdd = true;
        }

        if ( $this->isGranted( new AuthorizationAttribute( 'event', 'list' ) ) && $page == "homepage" ) {
            $bShowList = true;
        }

        if ( $page == "homepage" ) {
            $bShowAgenda = false;
        }

        $response = new Response();
        $response->setPrivate();
        $response->setVary( "X-User-Hash" );

        if ( $bShowAdd || $bShowAgenda || $bShowList ) {
            return $this->render( "EventAgendaBundle:Agenda:manage_event_bloc.html.twig", array(
                    "locationId" => $locationId,
                    "location" => $location,
                    "showAdd" => $bShowAdd,
                    "showList" => $bShowList,
                    "showAgenda" => $bShowAgenda
                ), $response
            );
        } else {
            return $response;
        }

    }

    /**
     * Load marker for new results (pagination)
     * @Route("/agenda/AjxLoadMap", name="_cg_load_google_map")
     */
    public function loadGoogleMapAction() {

        $locationId = $this->getRequest()->get("locationId");
        $limit = $this->getRequest()->get("page") * 4;
        $offset = 0;

        $contentService = $this->getRepository()->getContentService();
        $locationService = $this->getRepository()->getLocationService();
        $location = $locationService->loadLocation( $locationId );
        $content = $contentService->loadContentByContentInfo( $location->getContentInfo() );

        if ( $this->getRequest()->get( "form" ) ) {
            $aRequestForm = $this->getRequest()->get( "form" );
        }

        if ( isset( $aRequestForm ) ) {

            if ( isset( $aRequestForm["diaryWhere"] ) && $aRequestForm["diaryWhere"] != "" ) {
                $params["diaryWhere"] = $aRequestForm["diaryWhere"];
            }

            if ( isset( $aRequestForm['diaryWhen'] ) && $aRequestForm['diaryWhen'] != "" ) {
                $oSearchDate = DateTime::createFromFormat( "d/m/Y H:i:s", $data['diaryWhen']->format('d/m/Y') . " 00:00:00" );
                $timestamp = $oSearchDate->getTimestamp();
                $params["diaryWhen"] = $this->getLegacyKernel()->runCallback( function () use ( $timestamp ) {
                    return ezfSolrDocumentFieldBase::convertTimestampToDate( $timestamp );
                });
            }

            if ( isset( $aRequestForm['diaryTopic'] ) ) {
                $params["diaryTopic"] = $aRequestForm['diaryTopic'];
            } else {
                $aTmpTags = $content->getFieldValue( "tag" )->tags;
                $thematicSearch = array();
                foreach( $aTmpTags as $oTag ) {
                    $thematicSearch[$oTag->id] = $oTag->keyword;
                }
                $params["diaryTopic"] = $thematicSearch;
            }

        }

        $params["subtree"] = $locationId;
        $params["limit"] = $limit;
        $params["offset"] = $offset;
        $aResultSearch = $this->getResultSearch( $params );

        $aMapsInfos = $this->buildMapInfos( $aResultSearch );
        $response = new Response( json_encode( $aMapsInfos ) );
        return $response;
    }

    /**
     * Build array for google maps popin information
     * @param $aResultSearch
     * @return array
     */
    protected function buildMapInfos( $aResultSearch ) {
        $contentService = $this->getRepository()->getContentService();
        $aMapsInfos = array();
        foreach( $aResultSearch["SearchResult"] as $index=>$result ) {
            /**
             * @var Content $oEvent
             */
            $oEvent = $result["content"];
            $oRelationValue = $oEvent->getFieldValue( "event_place" );
            if($oRelationValue->destinationContentId != 0 && $oRelationValue->destinationContentId != null ){
                $oEventPlace = $contentService->loadContent( $oRelationValue->destinationContentId );
                $aMapsInfos[$oEventPlace->contentInfo->id][$index]["latitude"] = $oEventPlace->getFieldValue('google_map')->latitude;
                $aMapsInfos[$oEventPlace->contentInfo->id][$index]["longitude"] = $oEventPlace->getFieldValue('google_map')->longitude;

                $tagColor = \ThematicRepository::fetchObject( \ThematicRepository::definition(), null,array( 'EZTAGS_id' => $oEvent->getFieldValue('tag')->tags[0]->id ) );
                if ( $tagColor ) {
                    $aMapsInfos[$oEventPlace->contentInfo->id][$index]["color"] = $tagColor->attribute( "color_code" );
                }

                $aMapsInfos[$oEventPlace->contentInfo->id][$index]["image"] = $oEvent->getFieldValue( "main_image" )->uri;
                $aMapsInfos[$oEventPlace->contentInfo->id][$index]["title"] = $oEvent->getFieldValue( "title" )->text;
                $aMapsInfos[$oEventPlace->contentInfo->id][$index]["tag"] = $oEvent->getFieldValue( "tag" )->tags[0]->keyword;
                $aMapsInfos[$oEventPlace->contentInfo->id][$index]["introduction"] = $oEvent->getFieldValue( "introduction" )->xml->textContent;

                if ( $oEvent->getFieldValue( "begin_date" )->date ) {
                    $aMapsInfos[$oEventPlace->contentInfo->id][$index]["begin_date"] = $oEvent->getFieldValue( "begin_date" )->date->format( "d/m/Y" );

                    if ( $oEvent->getFieldValue( "end_date" )->date ) {
                        if ( $oEvent->getFieldValue( "begin_date" )->date->format( "d/m/Y" ) != $oEvent->getFieldValue( "end_date" )->date->format( "d/m/Y" ) ) {
                            $aMapsInfos[$oEventPlace->contentInfo->id][$index]["end_date"] = $oEvent->getFieldValue( "end_date" )->date->format( "d/m/Y" );
                        }
                    }
                }
            }

        }

        return $aMapsInfos;
    }

}
