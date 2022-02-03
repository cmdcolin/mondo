PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix owl: <http://www.w3.org/2002/07/owl#>
prefix oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix MONDO: <http://purl.obolibrary.org/obo/MONDO_>

DELETE {
  ?entity rdfs:subClassOf ?parent .	
  ?entity <http://purl.obolibrary.org/obo/IAO_0006012> ?date .
  ?entity oboInOwl:inSubset ?subset .
  ?entity oboInOwl:inSubset <http://purl.obolibrary.org/obo/mondo#obsoletion_candidate> .
  ?xref_anno oboInOwl:source ?source .
  ?entity rdfs:label ?label .
}

INSERT {
  ?xref_anno oboInOwl:source ?new_source .
  ?entity rdfs:label ?new_label .
  ?entity owl:deprecated true .
}

WHERE {
  VALUES ?entity { MONDO:0000000 }  .
    ?entity rdfs:label ?label .
    ?entity oboInOwl:inSubset <http://purl.obolibrary.org/obo/mondo#obsoletion_candidate> .
    
    ?xref_anno a owl:Axiom ;
           owl:annotatedSource ?entity ;
           owl:annotatedProperty ?property ;
           owl:annotatedTarget ?value ;
           oboInOwl:source ?source .
  
  	OPTIONAL {
  		?entity oboInOwl:inSubset ?subset .
    	FILTER(?subset != <http://purl.obolibrary.org/obo/mondo#obsoletion_candidate> )
  	}
    
  	OPTIONAL {
  		?entity <http://purl.obolibrary.org/obo/IAO_0006012> ?date .
  	}

   	FILTER NOT EXISTS { ?entity owl:deprecated true }
  	
  	BIND(REPLACE(str(?source), "MONDO:equivalent", "MONDO:obosoleteEquivalent") as ?new_source)
  	BIND(CONCAT("obsolete ",str(?label)) as ?new_label)
}