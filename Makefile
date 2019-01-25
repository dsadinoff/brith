#dots

PASSAGE_NAME=Exodus.10.1-11
#PASSAGE_NAME=Exodus.10.12-23
PASSAGE_URL_PARAM = $(PASSAGE_NAME)


# S2B=./sefaria2braille -e $(ENCODING)
FETCH=./fetchSefaria

PFILE_BASE = $(PASSAGE_NAME).utf8
PFILE = tmp/$(PFILE_BASE)
BRF_FILE = $(PASSAGE_NAME).$(ENCODING).$(DAGESHMODE).brf

PANGRAM_FILE = pangram.ashkenaz.$(ENCODING).$(DAGESHMODE)
PANGRAM_FILE_BRF =  $(PANGRAM_FILE).brf
export ENCODING=CP
export DAGESHMODE=HEH_BCFT
export ENCODE=./encodeHebrew -e $(ENCODING) -m $(DAGESHMODE)

#OUTPUTS += out5.$(ENCODING).html
OUTPUTS += tmp/$(PASSAGE_NAME).$(ENCODING).$(DAGESHMODE).html
OUTPUTS += tmp/$(BRF_FILE)
OUTPUTS += tmp/pangram.ashkenaz.$(ENCODING).$(DAGESHMODE).html
OUTPUTS += tmp/pangram.ashkenaz.$(ENCODING).$(DAGESHMODE).brf
OUTPUTS += tmp/summary.$(ENCODING).$(DAGESHMODE).html

$(PFILE) :
	$(FETCH) $(PASSAGE_URL_PARAM) > $@.tmp
	mv $@.tmp $@

tmp/$(BRF_FILE): $(PFILE)
	$(ENCODE) -a $(PFILE) > $@.tmp
	mv $@.tmp $@



tmp/$(PASSAGE_NAME).$(ENCODING).$(DAGESHMODE).html: $(PFILE)
	./make-html-with-brf $@ $(PFILE) $(BRF_FILE)


bo.utf8: bo.manifest.json
	$(FETCH) -j $< > $@.tmp
	mv $@.tmp $@

docs/bo.$(ENCODING).$(DAGESHMODE).brf: bo.utf8
	$(ENCODE)  -a $< > $@.tmp 
	mv $@.tmp $@


docs/bo.$(ENCODING).$(DAGESHMODE).html: bo.utf8 
	./make-html-with-brf $@ $< bo.$(ENCODING).$(DAGESHMODE).brf

bo:  docs/bo.$(ENCODING).$(DAGESHMODE).html docs/bo.$(ENCODING).$(DAGESHMODE).brf



tmp/$(PANGRAM_FILE_BRF): pangram.ashkenaz
	$(ENCODE) -a $< > $@.tmp
	mv $@.tmp $@


tmp/pangram.ashkenaz.$(ENCODING).$(DAGESHMODE).html: pangram.ashkenaz
	cat pre1.html  > $@.tmp
	$(ENCODE) -w --add-word-ids  $<  >> $@.tmp
	echo "<td>" >> $@.tmp
	$(ENCODE) --add-word-ids --add-space -u --highlight-taamim $< >> $@.tmp


	(echo "<br><a href='$(PANGRAM_FILE_BRF)' >Download BRF</a></div></td>" ) >> $@.tmp
	# echo "<tr><td><pre>" >> $@.tmp
	# oduni -h -s $< >> $@.tmp
	# echo "</pre><td><pre>" >> $@.tmp
	# $(ENCODE) -u $<|perl  -CS -lpe 's//\n/g'	 >> $@.tmp
	# echo "</pre></td>" >> $@.tmp
	echo "</table>" >> $@.tmp

	cat post-script.html  >> $@.tmp
	mv $@.tmp $@


tmp/summary.$(ENCODING).$(DAGESHMODE).html: tester.pl
	./tester.pl -m $(DAGESHMODE)  -e $(ENCODING) > $@.tmp;
	mv $@.tmp $@


push: $(OUTPUTS)
	cp $(OUTPUTS) docs
	-cp $(OUTPUTS) ~dsadinoff/www/tmp
	-cp $(OUTPUTS) brith.sadinoff.com/public/test


clean:
	-rm  $(OUTPUTS) bo.utf8 docs/bo*


all:
	# $(MAKE)  clean push ENCODING=CO
	$(MAKE) clean push ENCODING=CP
