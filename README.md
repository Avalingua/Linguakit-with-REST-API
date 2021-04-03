# Linguakit-with-REST-API
A REST API to access linguakit code.

## Linguakit
Multilingual toolkit for NLP: dependency parser, PoS tagger, NERC, multiword extractor, sentiment analysis, etc. 

## How to install
`sudo apt install cpanminus libplack-perl`
`sudo cpanm --installdeps .`

## How to deploy
`ubic-admin setup`
`cp scripts/ubic_linguakit ~/ubic/service/linguakit`
`ubic start linguakit`


## Experimental

### Fatpack help to pack dependencies in the script file (not needed now)

fatpack pack linguakit_api.pl >linguakit_api_packed.pl 