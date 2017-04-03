function [ prompt2ipa ] = ta_hVd_prompt_to_IPA()
%% TA_PROMPT_TO_IPA Convert SAMPA to IPA
% use by querying like: prompt2ipa('head') which will return '/hed/'
% uses chart from https://en.wikipedia.org/wiki/Speech_Assessment_Methods_Phonetic_Alphabet_chart_for_English for Australian English
prompt2ipa = containers.Map;
prompt2ipa('hard') = '/haːd/';
prompt2ipa('heed') = '/hiːd/';
prompt2ipa('hid') = '/hɪd/';
prompt2ipa('head') = '/hed/';
prompt2ipa('herd') = '/hɜːd/';
prompt2ipa('had') = '/hæd/';
prompt2ipa('hod') = '/hɔd/';
prompt2ipa('horde') = '/hoːd/';
prompt2ipa('hood') = '/hʊd/';
prompt2ipa('whod') = '/hʉːd/';
prompt2ipa('who''d') = '/hʉːd/';
prompt2ipa('hade') = '/hæɪd/';
prompt2ipa('hide') = '/hɑed/';
prompt2ipa('hoyd') = '/hoɪd/';
prompt2ipa('hode') = '/həʉd/';
prompt2ipa('howd') = '/hæɔd/';
prompt2ipa('heared') = '/hɪəd/';
prompt2ipa('haired') = '/heːd/';
prompt2ipa('hud')= '/hʌd/';

% prompt2ipa('a') = '/a/';
% prompt2ipa('U@') = '/ʊə/';
% prompt2ipa('j}:') = '/jʉː/';

end