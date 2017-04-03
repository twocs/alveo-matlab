function sMap= ta_batchtrain_lininit(self, SOMwidth)  
%% batchtrain algorithm
% input:
%    self: ta_data_class object
% output:
%    sMap: trained sMap


% stack the data for processing
my_data = self.ta_flat_stack();
tot_data = my_data.mfcc39;

sData = som_data_struct(tot_data);

gMap = gtm_make(sData, 'msize', [20 20]);

% TODO ????

    
RoughFin = 4; % rough phase neighbourhood radius
FinetuneFin = 0.5; % 0.5 is typical for small maps, and the smallest in general p.49
% SOMwidth = 20; % sent by outside

%% initialise SOM
% if ~exist('sMapN', 'var')
sMap = som_map_struct(size(sData.data, 2), 'msize', [SOMwidth, SOMwidth]);
sMap = som_lininit(sData, sMap);

%% train the SOM
for type = [RoughFin, FinetuneFin]
    if (type == RoughFin)
        sTrainN = som_train_struct(sMap,'phase','rough');
    else
        sTrainN = som_train_struct(sMap,'phase', 'finetune');
    end

    sMap = som_batchtrain(sMap, sData, sTrainN);  %, 'radius_ini', type * max(sMapN.topol.msize)/4, 'radius_fin', type, 'trainlen', SOMwidth * SOMwidth * 10, 'radius_fin', type , 'tracking',3
end

end