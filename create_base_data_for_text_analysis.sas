*Set up library to store project files;
libname ta '/folders/myshortcuts/program/TextAnalysis/SAS Files';
*Specify the path to the parts of speech file;
filename corpus 
    '/folders/myshortcuts/program/TextAnalysis/Corpus/sample_sas_forum.txt';
*Specify the path to the sentiment word file;
filename sent 
    '/folders/myshortcuts/program/TextAnalysis/Corpus/word_sentiment.txt';


*Import parts of speech file;
data ta.corpus;
    informat text $100. word $100. pos $8.;
    infile corpus dlm='D7'x termstr=CR truncover;
    input text $;
    word=scan (text, 1, '◊');
    pos=scan(text, 2, '◊');
    pos_length = length(pos);
    
    array _pos(7) $1 pos1-pos7;
    
    do i=1 to pos_length;
       _pos(i)=char(pos, i);
    end;
    
    drop i text;
    
run;

*Close file connection;
filename corpus;

*Import sentiment file;
data ta.sentiment;
informat word $50.;
infile sent dsd dlm=',' truncover firstobs=2;
input word $ happiness_rank happiness_average happiness_standard_deviation twitter_rank google_rank nyt_rank lyrics_rank;
run;

*close file connection;
filename sent;

*Create the pos lookup table;
proc format;
invalue $ pos_infmt
'N' = 'Noun'
'p' = 'Plural'
'h' = 'Noun Phrase'
'V' = 'Verb (usu participle)'
't' = 'Verb (transitive)'
'i' = 'Verb (intransitive)'
'A' = 'Adjective'
'v' = 'Adverb'
'C' = 'Conjunction'
'P' = 'Preposition'
'!' = 'Interjection'
'r' = 'Pronoun'
'D' = 'Definite Article'
'I' = 'Indefinite Article'
'o' = 'Nominative'
;
value $ pos_fmt
'N' = 'Noun'
'p' = 'Plural'
'h' = 'Noun Phrase'
'V' = 'Verb (usu participle)'
't' = 'Verb (transitive)'
'i' = 'Verb (intransitive)'
'A' = 'Adjective'
'v' = 'Adverb'
'C' = 'Conjunction'
'P' = 'Preposition'
'!' = 'Interjection'
'r' = 'Pronoun'
'D' = 'Definite Article'
'I' = 'Indefinite Article'
'o' = 'Nominative'
;
run;
