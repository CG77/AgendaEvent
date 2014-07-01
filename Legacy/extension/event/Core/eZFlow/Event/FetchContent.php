<?php

namespace ezPublishLegacy\CG77\Core\eZFlow\Event;

use eZ\Publish\API\Repository\Exceptions\NotFoundException;
use eZ\Publish\API\Repository\Exceptions\UnauthorizedException;
use Symfony\Component\Security\Core\Exception\AccessDeniedException;

class FetchContent implements \eZFlowFetchInterface {


    public function fetch( $parameters, $publishedAfter, $publishedBeforeOrAt )
    {
        $classIdentifier            =	$parameters["class_identifier"];
        $limit						= 	array();
        $nodeID = '70';

        // On fixe la limite en regardant les paramètres

        if (isset($parameters["limit"])	&&	$parameters["limit"] && is_numeric((int)$parameters["limit"]))
            $limit['SearchLimit']	=	(int)$parameters["limit"];
        else
            $limit['SearchLimit'] = 10; // surcharge de la limit par defaut de ezfind


        // On pend toujours le même ordre : du plus récent au plus ancien
        $sortBy = array('published' => 'desc');

        if(isset($parameters['sort_by']) AND $parameters['sort_by']!="")
            $sortBy = $parameters['sort_by'];

        $solrFilter			=	array();


        if($publishedAfter != '*')
            $TimestampAfter = \ezfSolrDocumentFieldBase::convertTimestampToDate($publishedAfter);
        else
            $TimestampAfter = '*';


        $solrFilter[]	=	array(	\eZSolr::getMetaFieldName('published','filter').
        ':['.$TimestampAfter.' TO '.\ezfSolrDocumentFieldBase::convertTimestampToDate($publishedBeforeOrAt).']'	);

        $solrFilter[] = array( "attr_not_to_miss_insert_t:Oui" );

        $searchResult = \eZFunctionHandler::execute('ezfind', 'search', array(
                                                                        'subtree_array' => array($nodeID),
                                                                        'class_id' => $classIdentifier,
                                                                        'filter' => $solrFilter,
                                                                        'as_objects' => false,
                                                                        'limit' => $limit,
                                                                        'sort_by' => array('published' => 'desc')
                ));

        $result			=	$searchResult["SearchResult"];
        $total          =   $searchResult["SearchCount"];

        $fetchResult 	=	array();

        if ( $result ) {
            foreach ( $result as $item )
            {
                try{
                    $fetchResult[]	=	array(
                        'object_id' 		=> $item['id'],
                        'node_id'			=> $item['node_id'][0],
                        'ts_publication'	=> $item['published'],
                        'class_identifier'	=> $item['class_identifier'],
                        'name'				=> $item['name']
                    );
                }catch(UnauthorizedException $e){

                }catch(AccessDeniedException $e){

                }catch(NotFoundException $e){}

            }
        }

        return $fetchResult;
    }
}