#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
binmode STDIN, ':utf8';
binmode STDOUT, ':utf8';

use Data::Dump qw(dump);
use JSON;
use Cwd 'getcwd';
use Dancer2;

############################
# Config
############################

my $PROGS = "scripts";
my $DIRPARSER = "parsers";
my $basedir = getcwd($0);

my @lings = ("es","pt","gl","en");
@lings = ("es");
for my $LING (@lings) {
	#print $LING."\n";

	do "$basedir/linguakit_original/$DIRPARSER/parserDefault-$LING.perl";
	do "$basedir/linguakit_original/$PROGS/AdapterFreeling-${LING}.perl";
	do "$basedir/linguakit_original/$PROGS/saidaCoNLL-fa.perl";

	do "$basedir/linguakit_original/tagger/$LING/sentences-${LING}_exe.perl";
	do "$basedir/linguakit_original/tagger/$LING/tokens-${LING}_exe.perl";
	do "$basedir/linguakit_original/tagger/$LING/splitter-${LING}_exe.perl";
	do "$basedir/linguakit_original/tagger/$LING/lemma-${LING}_exe.perl";
	do "$basedir/linguakit_original/tagger/$LING/ner-${LING}_exe.perl";
	do "$basedir/linguakit_original/tagger/$LING/tagger-${LING}_exe.perl" ;
	do "$basedir/linguakit_original/tagger/$LING/nec-${LING}_exe.perl";

}

do "$basedir/linguakit_original/tagger/coref/coref_exe.perl";

do "$basedir/linguakit_original/sentiment/nbayes.perl";

do "$basedir/linguakit_original/mwe/mwe.perl";
do "$basedir/linguakit_original/mwe/filtro_galextra.perl";
do "$basedir/linguakit_original/mwe/six_tokens.perl";

do "$basedir/linguakit_original/keywords/keywords_exe.perl";
do "$basedir/linguakit_original/triples/triples_exe.perl";
do "$basedir/linguakit_original/linking/linking_exe.perl";
do "$basedir/linguakit_original/summarizer/summarizer_exe.perl";
do "$basedir/linguakit_original/summarizer/Sentence.pl";
do "$basedir/linguakit_original/conjugator/conjugator_exe.perl";
do "$basedir/linguakit_original/avalingua/avalingua_exe.perl";

do "$basedir/linguakit_original/lanrecog/lanrecog.perl";
do "$basedir/linguakit_original/lanrecog/build_lex.perl";

do "$basedir/linguakit_original/kwic/kwic.perl";

############## API ################

get '/' => sub { "Hello World" };



post '/v2.0/:module' => sub {
    header 'Content-Type' => 'application/json';
    header 'Access-Control-Allow-Origin' => '*';
    
	my $LING = body_parameters->get('lang');
	my $MOD = route_parameters->get('module');
	my $TEXT = body_parameters->get('text');
	my $OUTPUT = body_parameters->get('output');

	print "Hello. lang: ". $LING ."  mod: ". $MOD . " text: ". $TEXT ."\n\n";

    if($MOD eq "dep"){
        if($OUTPUT eq "conll"){  ##Conll dependency output
            my $list = CONLL::conll(Parser::parse(AdapterFreeling::adapter(Tagger::tagger(Ner::ner(Splitter::splitter(Tokens::tokens(Sentences::sentences([$TEXT])))))), '-fa'));
            return encode_json($list);
        }elsif($OUTPUT eq "fa"){
            my $list = Parser::parse(AdapterFreeling::adapter(Tagger::tagger(Ner::ner(Splitter::splitter(Tokens::tokens(Sentences::sentences([$TEXT])))))),  '-fa');
            return encode_json($list);
        }elsif($OUTPUT eq "c"){
            my $list = Parser::parse(AdapterFreeling::adapter(Tagger::tagger(Ner::ner(Splitter::splitter(Tokens::tokens(Sentences::sentences([$TEXT])))))), '-c');
            return encode_json($list);
        }else{
            my $list = Parser::parse(AdapterFreeling::adapter(Tagger::tagger(Ner::ner(Splitter::splitter(Tokens::tokens(Sentences::sentences([$TEXT])))))), '-a');
            return encode_json($list);
        }

    } elsif($MOD eq "rel"){  ##Triples extration (Open Information Extraction)
        my $list = Triples::triples(CONLL::conll(Parser::parse(AdapterFreeling::adapter(Tagger::tagger(Ner::ner(Splitter::splitter(Tokens::tokens(Sentences::sentences([$TEXT])))))), '-fa')));
        return encode_json($list);
    }elsif($MOD eq "tagger"){
        if ($OUTPUT eq "ner"){  ##PoS tagging with ner
            my $list = Tagger::tagger(Ner::ner(Splitter::splitter(Tokens::tokens(Sentences::sentences([$TEXT])))));
            return encode_json($list);
        }elsif($OUTPUT eq "nec"){  ##PoS tagging with nec
            my $list = Nec::nec(Tagger::tagger(Ner::ner(Splitter::splitter(Tokens::tokens(Sentences::sentences([$TEXT]))))));
            return encode_json($list);
        }else{  ##by default PoS tagging
            my $list = Tagger::tagger(Lemma::lemma(Splitter::splitter(Tokens::tokens(Sentences::sentences([$TEXT])))));
            return encode_json($list);
        }
    }elsif($MOD eq "coref"){
        my $Mentions_id = {};#<ref><hash><integer>
        if($OUTPUT eq "crnec"){  ##PoS tagging with Coreference Resolution and NEC correction
            my $list = Coref::coref(0, 1, Nec::nec(Tagger::tagger(Ner::ner(Splitter::splitter(Tokens::tokens(Sentences::sentences([$TEXT])))))), 500, $Mentions_id);
            return encode_json($list);
        }else{  ##PoS tagging with Coreference Resolution
            my $list = Coref::coref(1, 0, Nec::nec(Tagger::tagger(Ner::ner(Splitter::splitter(Tokens::tokens(Sentences::sentences([$TEXT])))))), 500, $Mentions_id);
            return encode_json($list);
        }
    }elsif($MOD eq "mwe"){  ##multiword extraction
        if($OUTPUT eq "log"){
            my $list = Mwe::mwe(SixTokens::sixTokens(FiltroGalExtra::filtro(Tagger::tagger(Ner::ner(Splitter::splitter(Tokens::tokens(Sentences::sentences([$TEXT]))))))),"-log",1);
            return encode_json($list);
        }elsif($OUTPUT eq "scp"){
            my $list = Mwe::mwe(SixTokens::sixTokens(FiltroGalExtra::filtro(Tagger::tagger(Ner::ner(Splitter::splitter(Tokens::tokens(Sentences::sentences([$TEXT]))))))),"-scp",1);
            return encode_json($list);
        }elsif($OUTPUT eq "mi"){
            my $list = Mwe::mwe(SixTokens::sixTokens(FiltroGalExtra::filtro(Tagger::tagger(Ner::ner(Splitter::splitter(Tokens::tokens(Sentences::sentences([$TEXT]))))))),"-mi",1);
            return encode_json($list);
        }elsif($OUTPUT eq "cooc"){
            my $list = Mwe::mwe(SixTokens::sixTokens(FiltroGalExtra::filtro(Tagger::tagger(Ner::ner(Splitter::splitter(Tokens::tokens(Sentences::sentences([$TEXT]))))))),"-cooc",1);
            return encode_json($list);
        }else{
            my $list = Mwe::mwe(SixTokens::sixTokens(FiltroGalExtra::filtro(Tagger::tagger(Ner::ner(Splitter::splitter(Tokens::tokens(Sentences::sentences([$TEXT]))))))),"-chi",1);
            return encode_json($list);
        }

    }elsif($MOD eq "key"){
        my $list = Keywords::keywords(Tagger::tagger(Ner::ner(Splitter::splitter(Tokens::tokens(Sentences::sentences([$TEXT]))))));	
        return encode_json($list);

    }elsif($MOD eq "sent"){  ##sentiment analysis
        Nbayes::load($LING);
        my $result = Nbayes::nbayes(Tagger::tagger(Ner::ner(Splitter::splitter(Tokens::tokens(Sentences::sentences([$TEXT]))))));    
        my $idontknow = Nbayes::end(); # I don't know why this is stored to a variable
       return encode_json($result);

    }elsif($MOD eq "recog"){  ##language recognition
        my %Peso = ();#Line acumulator
        my $ling = LanRecog::langrecog(Tokens::tokens(Sentences::sentences([$TEXT])), \%Peso);
        return encode_json($ling);

    }elsif($MOD eq "tok"){  ##tokenizer
        if($OUTPUT eq "sort"){  ##tokenizer with sorting by frequency
            my %count = ();
            my $list = Splitter::splitter(Tokens::tokens(Sentences::sentences([$TEXT])));
            for my $token (@{$list}){
                $count{$token} = $count{$token} ? $count{$token} + 1 : 1;
            }
            my @out;
            for my $result (sort {$count{$b} <=> $count{$a}} keys %count){
                push(@out, "$count{$result}\t$result");
            }
            return encode_json(@out);
        }elsif($OUTPUT eq "split"){
            my $list = Splitter::splitter(Tokens::tokens(Sentences::sentences([$TEXT])));
            return encode_json($list);
        }else{
            my $list = Tokens::tokens(Sentences::sentences([$TEXT]));
            return encode_json($list);
        }
        

    }elsif($MOD eq "seg"){  ##segmentation
        my $list = Sentences::sentences([$TEXT]);
        return encode_json($list);

    }elsif($MOD eq "lem"){  ##lemmatizer and PoS tagging
        my $list = Lemma::lemma(Splitter::splitter(Tokens::tokens(Sentences::sentences([$TEXT]))));
        return encode_json($list);

    }elsif($MOD eq "kwic"){  ##key word in context (kwic) or concordances with just tokens as context
        my $list = Kwic::kwic(Sentences::sentences([$TEXT]),$OUTPUT);
        return encode_json($list);

    }elsif($MOD eq "link"){  ##entity linking
        if($OUTPUT eq "xml"){
            my $result = Linking::linking($TEXT,$LING,"xml");
            return encode_json($result);
        }else{
            my $result = Linking::linking($TEXT,$LING,"json");
            return encode_json($result);
        }

    }elsif($MOD eq "aval"){  ## avalingua
        if($OUTPUT eq "xml"){
            my $result = Avalingua::avalingua($TEXT,$LING,"xml");
            return encode_json($result);
        }else{
            my $result = Avalingua::avalingua($TEXT,$LING,"json");
            return encode_json($result);
        }

    }elsif($MOD eq "sum") {  ##summarizer
		my ($result) = Summarizer::summarizer($TEXT,$LING,$OUTPUT);
		return encode_json($result);
    }elsif($MOD eq "conj"){  ##conjugator
        if($LING eq 'pt' && ($OUTPUT eq 'pe' || $OUTPUT eq 'pb' || $OUTPUT eq 'peb' || $OUTPUT eq 'pbn')){
            my $result = Conjugator::conjugator($TEXT,$LING,'-'.$OUTPUT);
            return encode_json($result);
        }else{
            my $result = Conjugator::conjugator($TEXT,$LING);
            return encode_json($result);
        }
    }
};


dance;