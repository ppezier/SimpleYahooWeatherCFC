/**
 * @author Patrick Pézier - http://patrick.pezier.com
 * Composant ColdFusion communiquant avec l'API Yahoo Weather
 * URL : https://developer.yahoo.com/weather/
 */
component
	accessors="true"
	output="false"
	{

		/* encodage */
		pageencoding "utf-8";

		/* propriétés */
		property name="ClientId"		type="string"; // Consumer Key
		property name="ClientSecret"	type="string"; // Consumer Secret

		/* constantes */
		this.API_URL = "https://query.yahooapis.com/v1/public/yql"; // url racine de l'API

		/**
		 * constructeur
		 */
		public yahooWeather function init( string client_id="", string client_secret="" ){
			this.setClientId(arguments.client_id);
			this.setClientSecret(arguments.client_secret);
			return(this);
		}


		/**
		 * Appelle l'API
		 * @location.hint		ville
		 * @location.details	informations souhaitées (condition, wind... ou * pour tout)
		 * @format.hint			format de la réponse (json)
		 */
		public any function callAPI( string location="", string details="*", string format="json" ){


			/* préparation de la YQL query */
			if (compare(arguments.details,"*"))
				arguments.details = 'item.' & arguments.details;
			var yql_query = "select " & arguments.details & " from weather.forecast where u='c' and woeid in (select woeid from geo.places(1) where text='" & arguments.location & "')";

			/* préparation de l'appel à l'API Yahoo Weather */
			var httpService = new http( method="GET", charset="utf-8" );
			local.httpService.setUrl( this.API_URL );
			local.httpService.addParam( type="URL", name="q", value="#local.yql_query#" );
			local.httpService.addParam( type="URL", name="format", value="#arguments.format#" );

			/* appel de l'API */
			var result = httpService.send().getPrefix();

			/**
			 * vérification du contenu renvoyé
			 */
			if (val(local.result.statusCode) neq 200) // le serveur a répondu avec un code invalide
				return( "Erreur de réponse HTTP : " & local.result.statusCode );
			else if (not isJSON(local.result.fileContent)) // la réponse n'est pas au format JSON
				return( "Erreur de format de réponse" );

			/**
			 * traitement du contenu renvoyé
			 */
			json = deserializeJSON(local.result.fileContent);
			if (!val(json.query.count)) // le JSON ne contient pas de données
				return( "Pas de résultats" );
			else // tout s'est bien passé
				return( json.query.results.channel );

		} // fin function callAPI

	}
