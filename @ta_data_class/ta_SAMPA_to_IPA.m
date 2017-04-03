function [ sampa2ipa ] = ta_get_sampa2ipa()
%% TA_SAMPA_TO_IPA Convert SAMPA to IPA
% use by querying like: sampa2ipa('d') which will return 'd'
% uses chart from https://en.wikipedia.org/wiki/Speech_Assessment_Methods_Phonetic_Alphabet_chart_for_English for Australian English
sampa2ipa = containers.Map;
sampa2ipa('p') = 'p';
sampa2ipa('b') = 'b';
sampa2ipa('t') = 't';
sampa2ipa('d') = 'd';
sampa2ipa('tS') = 'tʃ';
sampa2ipa('dZ') = 'dʒ';
sampa2ipa('k') = 'k';
sampa2ipa('g') = 'ɡ';
sampa2ipa('f') = 'f';
sampa2ipa('v') = 'v';
sampa2ipa('T') = 'θ';
sampa2ipa('D') = 'ð';
sampa2ipa('s') = 's';
sampa2ipa('z') = 'z';
sampa2ipa('S') = 'ʃ';
sampa2ipa('Z') = 'ʒ';
sampa2ipa('h') = 'h';
sampa2ipa('m') = 'm';
sampa2ipa('n') = 'n';
sampa2ipa('N') = 'ŋ';
sampa2ipa('l') = 'l';
sampa2ipa('r') = 'ɹ';
sampa2ipa('w') = 'w';
sampa2ipa('j') = 'j';
sampa2ipa('W') = 'ʍ';
sampa2ipa('x') = 'x';
sampa2ipa('a:') = 'aː';
sampa2ipa('i:') = 'iː';
sampa2ipa('I') = 'ɪ';
sampa2ipa('e') = 'e';
sampa2ipa('3:') = 'ɜː';
sampa2ipa('{') = 'æ';
sampa2ipa('a:') = 'aː';
sampa2ipa('a') = 'a';
sampa2ipa('O') = 'ɔ';
sampa2ipa('o:') = 'oː';
sampa2ipa('U') = 'ʊ';
sampa2ipa('}:') = 'ʉː';
sampa2ipa('@') = 'ə';
sampa2ipa('@') = 'ə';
sampa2ipa('{I') = 'æɪ';
sampa2ipa('Ae') = 'ɑe';
sampa2ipa('oI') = 'oɪ';
sampa2ipa('@}') = 'əʉ';
sampa2ipa('{O') = 'æɔ';
sampa2ipa('I@') = 'ɪə';
sampa2ipa('e:') = 'eː';
sampa2ipa('U@') = 'ʊə';
sampa2ipa('j}:') = 'jʉː';

%sampa2ipa('j}:') = 'ɑɹ';


% silence tag
sampa2ipa('<p:>') = '(...)';

% also some X-SAMPA
sampa2ipa('6') = 'ɐ';

% assuming the 6: is just r-coloured 6
sampa2ipa('6:') = 'ɐ:';

% @ta * means multiple labels
sampa2ipa('*') = '*';

% @ta null value labels
sampa2ipa('') = '';
end