#!/bin/sh

#HOST="localhost:3000/v2.0"
#HOST="http://api.linguakit.com/v2.0"
HOST="http://api.linguakit.com:3000/v2.0"
curl -X POST -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" -d "lang=es&output=fa&text=Rosalía es una niña excepcionalmente buena."  $HOST/dep
echo "\n"
curl -X POST -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" -d "lang=es&output=conll&text=Más de 20.000 voluntarios han participado en la tercera fase de las pruebas clínicas organizadas por la universidad de Oxford, que ya dio buenos resultados de seguridad en la segunda fase. En el último experimento, hubo 131 positivos: 30 casos en personas que habían recibido dos dosis de este antídoto y 101 en el grupo de control que recibió una inyección inocua. La eficacia de la vacuna subió al 90% en un grupo de voluntarios a los que se dio media dosis inicial seguida de una dosis completa. No han registrado casos graves ni hospitalizaciones entre las personas que recibieron la vacuna, según el comunicado de Oxford."  $HOST/rel
echo "\n"
curl -X POST -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" -d "lang=es&output=conll&text=Rosalía es una niña excepcionalmente buena."  $HOST/tagger
echo "\n"
curl -X POST -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" -d "lang=es&output=log&text=Más de 20.000 voluntarios han participado en la tercera fase de las pruebas clínicas organizadas por la universidad de Oxford, que ya dio buenos resultados de seguridad en la segunda fase. En el último experimento, hubo 131 positivos: 30 casos en personas que habían recibido dos dosis de este antídoto y 101 en el grupo de control que recibió una inyección inocua. La eficacia de la vacuna subió al 90% en un grupo de voluntarios a los que se dio media dosis inicial seguida de una dosis completa. No han registrado casos graves ni hospitalizaciones entre las personas que recibieron la vacuna, según el comunicado de Oxford."  $HOST/mwe
echo "\n"
curl -X POST -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" -d "lang=es&output=scp&text=Más de 20.000 voluntarios han participado en la tercera fase de las pruebas clínicas organizadas por la universidad de Oxford, que ya dio buenos resultados de seguridad en la segunda fase. En el último experimento, hubo 131 positivos: 30 casos en personas que habían recibido dos dosis de este antídoto y 101 en el grupo de control que recibió una inyección inocua. La eficacia de la vacuna subió al 90% en un grupo de voluntarios a los que se dio media dosis inicial seguida de una dosis completa. No han registrado casos graves ni hospitalizaciones entre las personas que recibieron la vacuna, según el comunicado de Oxford."  $HOST/mwe
echo "\n"
curl -X POST -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" -d "lang=gl&text=Rosalía xoga en Lugo con Feijoo, mentres na ONU debaten o futuro da Turkía de Erdogan."  $HOST/tagger
echo "\n"
curl -X POST -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" -d "lang=gl&text=Rosalía xugaba en Lugo con Feijoo, mientras en a ONU debaten os futuros da Turkía de Erdogan."  $HOST/ava
echo "\n"
curl -X POST -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" -d "lang=es&output=5&text=Más de 20.000 voluntarios han participado en la tercera fase de las pruebas clínicas organizadas por la universidad de Oxford, que ya dio buenos resultados de seguridad en la segunda fase. En el último experimento, hubo 131 positivos: 30 casos en personas que habían recibido dos dosis de este antídoto y 101 en el grupo de control que recibió una inyección inocua. La eficacia de la vacuna subió al 90% en un grupo de voluntarios a los que se dio media dosis inicial seguida de una dosis completa. No han registrado casos graves ni hospitalizaciones entre las personas que recibieron la vacuna, según el comunicado de Oxford."  $HOST/sum
echo "\n"
curl -X POST -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" -d "lang=es&text=decir" $HOST/conj
echo "\n"
