# To download USGS Protected Area database.
#	I looked up the URL on the USGS website and then used it on the server to download it 
#	directly to the same server as the database. Zip file contains shapefile.

sudo wget "https://www.sciencebase.gov/catalog/file/get/56bba648e4b08d617f657960?f=__disk__bb%2F1d%2F64%2Fbb1d64d7adb8aeb0b6f75d347077ddc1406d8a53" -O pad.zip --progress=bar

sudo mkdir gisdata 

sudo unzip pad.zip ./pad/

sudo mount -t cifs //geoservicesdiag563.file.core.windows.net/gisdata ./gisdata -o vers=3.0,username=geoservicesdiag563,password=gbEtb5mlwQjnvEkw8w7CTGIZ3nHesLgPlSvGw8vw8hyPEAWsqNEjfGLM51QLWnpQpQFVQqwNfldxvTvWQjxwiw==,dir_mode=0777,file_mode=0777
