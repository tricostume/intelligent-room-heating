%--------------------Università degli Studi di Genova----------------------
%_________________________________EMARO+___________________________________
%Title: Marketing strategy
%Period of preparation: 
%Authors: Ernesto Denicia, Emmanuele Vestito, Rocco Caravelli
%Script: Loading the marketing strategy of the hotel, this meaning
% the way the hotel opens its possibilities to every kind of client.
% E.g. If a person asks for a single bedroom but the demand is not
% big and the energetic constraints allow it, he/she might get
% a more expensive room for the same price in order to improve
% his satisfaction. This naturally will only happen IFF the
% constraints allow it.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
global general_room_types general_compatibility

general_room_types = {'111';'112';'113';'121';'122';'123';'132';...
                      '133';'142';'143';'213';'223';'233';'243'};
general_room_number = size(general_room_types,1);
% Fill in compatibility rooms
general_compatibility.r1 = {0};
general_compatibility.r2 = {'111','122','132'};
general_compatibility.r3 = {'111','112','122','123', '132', '133'};
general_compatibility.r4 = {'111'};
general_compatibility.r5 = {'111','112','132'};
general_compatibility.r6 = {'111','112','113','122', '132', '133'};
general_compatibility.r7 = {'111','112','122'};
general_compatibility.r8 = {'111','112','113','122', '123', '132'};
general_compatibility.r9 = {0};
general_compatibility.r10 = {'142'};
general_compatibility.r11 = {'111','112','113', '122', '123', '223', ...
                             '132', '133', '233'};
general_compatibility.r12 = {'111','112','113', '213', '122', '123', ...
                             '132', '133', '233'};
general_compatibility.r13 = {'111','112','113', '122', '123', '223', ...
                             '132', '133', '213'};
general_compatibility.r14 = {'142', '143'};