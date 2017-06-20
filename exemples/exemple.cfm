<cfscript>

    /* récupération de la config de l'API */
    config = deserializeJson(fileRead(expandPath("./config.json")));

    /* Instantiation */
    yahooWeather = new yahooWeather( client_id=config.client_id, client_secret=config.client_secret );

    /* Récup de la météo */
    meteo = yahooWeather.callAPI( location="Lorient, France", details="condition" );
    WriteDump(meteo.item.condition);

</cfscript>
