$a = New-WebServiceProxy 'http://www.webservicex.net/globalweather.asmx?WSDL'

$a.GetCitiesByCountry('Sweden')

$a.GetWeather('Stockholm / Arlanda', 'Sweden')