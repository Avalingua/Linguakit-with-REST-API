#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
binmode STDIN, ':utf8';
binmode STDOUT, ':utf8';

use Dancer2;

############################
# Config
############################

my $PROGS = "scripts";
my $DIRPARSER = "parsers";

my @lings = ("es","pt","gl","en");
for my $LING (@lings) {
	#print $LING."\n";

	do "./linguakit_original/linguakit_original/$DIRPARSER/parserDefault-$LING.perl";
	do "./linguakit_original/$PROGS/AdapterFreeling-${LING}.perl";
	do "./linguakit_original/$PROGS/saidaCoNLL-fa.perl";

	do "./linguakit_original/tagger/$LING/sentences-${LING}_exe.perl";
	do "./linguakit_original/tagger/$LING/tokens-${LING}_exe.perl";
	do "./linguakit_original/tagger/$LING/splitter-${LING}_exe.perl";
	do "./linguakit_original/tagger/$LING/lemma-${LING}_exe.perl";
	do "./linguakit_original/tagger/$LING/ner-${LING}_exe.perl";
	do "./linguakit_original/tagger/$LING/tagger-${LING}_exe.perl" ;
	do "./linguakit_original/tagger/$LING/nec-${LING}_exe.perl";

}

do "./linguakit_original/tagger/coref/coref_exe.perl";

do "./linguakit_original/sentiment/nbayes.perl";

do "./linguakit_original/mwe/mwe.perl";
do "./linguakit_original/mwe/filtro_galextra.perl";
do "./linguakit_original/mwe/six_tokens.perl";

do "./linguakit_original/keywords/keywords_exe.perl";
do "./linguakit_original/triples/triples_exe.perl";
do "./linguakit_original/linking/linking_exe.perl";
do "./linguakit_original/summarizer/summarizer_exe.perl";
do "./linguakit_original/summarizer/Sentence.pl";
do "./linguakit_original/conjugator/conjugator_exe.perl";
do "./linguakit_original/avalingua/avalingua_exe.perl";

do "./linguakit_original/lanrecog/lanrecog.perl";
do "./linguakit_original/lanrecog/build_lex.perl";

do "./linguakit_original/kwic/kwic.perl";

############## API ################

get '/' => sub { "Hello World" };



post '/:module' => sub {
	my $LING = body_parameters->get('lang');
	my $MOD = route_parameters->get('module');
	my $TEXT = body_parameters->get('text');
	my $STRING = body_parameters->get('input');


    $TEXT = 'Los primeros resultados del estudio de la fase 3 de la vacuna del laboratorio anglo-sueco AstraZeneca y la universidad británica de Oxford muestran que tiene una eficacia media del 70.4%, según han dado a conocer este lunes. Los investigadores han señalado que "es eficaz al prevenir que muchas personas enfermen y se ha demostrado que funciona bien en diferentes grupos de edad". Más de 20.000 voluntarios han participado en la tercera fase de las pruebas clínicas organizadas por la universidad de Oxford, que ya dio buenos resultados de seguridad en la segunda fase. En el último experimento, hubo 131 positivos: 30 casos en personas que habían recibido dos dosis de este antídoto y 101 en el grupo de control que recibió una inyección inocua. La eficacia de la vacuna subió al 90% en un grupo de voluntarios a los que se dio media dosis inicial seguida de una dosis completa. No han registrado casos graves ni hospitalizaciones entre las personas que recibieron la vacuna, según el comunicado de Oxford. Pfizer y Moderna han anunciado en las últimas semanas que la eficacia de sus vacunas, según los resultados preliminares, es del 95%. La opción británica es más barata y fácil de conservar, frente a la necesidad de mantener a temperaturas excepcionalmente bajas la vacuna creada por Pfizer y BioNTech (entre -70 ºC y -80 ºC ) y Moderna (-20 ºC). En el caso de Oxford, puede mantenerse almacenada a una temperatura de entre 2 y 8 ºC. El 19 de noviembre, los investigadores informaron de que la segunda fase de pruebas clínicas demostraba que su vacuna es segura, con pocos efectos secundarios, en personas sanas incluso de más de 70 años y provoca una respuesta inmune en todos los grupos de edad, tanto con una dosis baja como estándar. Sarah Gilbert, profesora de vacunología de Oxford y responsable del proyecto, ha declarado que el anuncio "nos sitúa un paso más cerca del momento en que podremos usar las vacunas para poner fin a la devastación causada por la covid-19". "Continuaremos trabajando con los reguladores (que deben autorizar la vacuna). Ha sido un privilegio ser parte de un esfuerzo multinacional que recogerá beneficios para todo el mundo", ha afirmado. La vacuna ChAdOx1 nCoV-19 está constituida por virus que afectan a chimpancés y han sido modificados para que se parezcan al SARS-CoV-2. Cuando esta vacuna se inocula, el sistema inmunitario reacciona como si fuera el coronavirus. La de Pfizer y Moderna se desarrollan con la tecnología conocida como ARN mensajero o ARNm, que consiste en "la producción de la proteína Spike (S) del virus SARS-CoV-2 (forma parte de los "pinchos" del coronavirus) a través de ARN en las propias células del cuerpo humano".';

	print "Hello. lang: ". $LING ."  mod: ". $MOD . " text: ". $TEXT ."\n";
	
	if($MOD eq "sum") {  ##summarizer
		my ($result) = Summarizer::summarizer($TEXT,$LING,);
		return "$result\n";
	}
		
    

};


dance;