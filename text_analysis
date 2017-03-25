*Create sample data;
data random_sentences;
    infile cards truncover;
    informat sentence $256.;
    input sentence $256.;
    cards;
This is a random sentence
This is another random sentence
Happy Birthday
My job sucks.
This is a good idea, not.
This is an awesome idea!
How are you today?
Does this make sense?
Have a great day!
;
    ;
    ;
    ;

*Partition into words;
data f1;
    set random_sentences;
    id=_n_;
    nwords=countw(sentence);
    nchar=length(compress(sentence));

    do word_order=1 to nwords;
        word=scan(sentence, word_order);
        output;
    end;
run;

*Add happiness index and pos;

proc sql ;
    create table scored as 
    select a.*, b.happiness_rank, c.pos, c.pos1
    from f1 as a 
    left join ta.sentiment as b 
    on a.word=b.word 
    left join ta.corpus as c
    on a.word=c.word
    order by sentence, word_order;
quit;

*Calculate sentence happiness score;
proc sql;
create table sentence_sentiment as
select distinct sentence, sum(happiness_rank) as sentiment
from scored
group by id;
quit;
