<?php

namespace Event\AgendaBundle\Controller;


use Novactive\eZNovaExtraBundle\Controller\BaseController;
use Symfony\Component\HttpFoundation\Response;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;

class AjaxController extends BaseController {

    /**
     * @param $iParentId
     * @Route("/Eventpage/AjxSubEvents/{iParentId}", name="_cg_eventpage_tags")
     * @return array
     */
    public function getSubEventsAction( $iParentId ) {

        $tagsService = $this->get( "ezpublish.api.service.tags");
        $oParentTag = $tagsService->loadTag( $iParentId );
        $aTmpChildrenTags = $tagsService->loadTagChildren( $oParentTag );
        $aChildrenTags = array();

        if ( $aTmpChildrenTags ) {
            foreach ( $aTmpChildrenTags as $oTmpChildren ) {
                $aChildrenTags[] = array(
                    "id" => $oTmpChildren->id,
                    "keyword" => $oTmpChildren->keyword
                );
            }
        }

        $response = new Response( json_encode( $aChildrenTags ) );
        return $response;

    }

} 