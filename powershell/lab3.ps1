get-ciminstance win32_networkadapterconfiguration | 
	where-object IPEnabled -eq True | 
	ft -autosize -Wrap Index, Description, IPAddress, IPSubnet, DNSDomain, DNSServerSearchOrder