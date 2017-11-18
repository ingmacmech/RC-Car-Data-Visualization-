function [y1] = myNeuralNetworkFunction_2(x1)
%MYNEURALNETWORKFUNCTION_2 neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 17-Nov-2017 10:45:08.
% 
% [y1] = myNeuralNetworkFunction_2(x1) takes these arguments:
%   x = 3xQ matrix, input #1
% and returns:
%   y = 1xQ matrix, output #1
% where Q is the number of samples.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [3048;3087;0];
x1_step1.gain = [0.000677966101694915;0.000252175009456563;5.65961784845383e-08];
x1_step1.ymin = -1;

% Layer 1
b1 = [-7.4189687322895743;-7.4710183674483961;7.2524990908447791;7.1482161507902644;10.065624666085053;7.4555938995776279;6.8393290280784802;-6.7399516399139694;20.946538771819725;6.5251186860942312;-7.0476486741355471;-6.022189484486927;6.2485421486113957;5.821661820187332;-6.9969418494658253;7.0034522560113821;-5.1711391476487414;-5.7381560498740445;5.6581335092675547;6.6134480366127439;5.4173292537371021;-5.9251280732520497;5.2303139192431169;-5.6188466459266024;4.3056584235424653;8.0511825119406222;-4.8355451660414479;6.7291919524373345;4.8056863734185633;-7.0869425969006334;-4.8264938621235505;-6.7970069707897496;-4.2364994174323858;3.8601657986586551;3.9426875613324701;-3.7546047527208857;-3.1617863935665182;-3.2953012569809919;-3.4415622473274134;3.5873363722450611;8.9479604295139126;-6.0128716710874457;-2.9106389454140973;-5.0834754562143072;3.4963874332555558;0.70254414040195445;-1.5137760438999539;4.3143707942535885;2.2137243666706152;-4.4677738123471986;-3.8893328456158329;2.6351704351269127;0.7291607156125206;-2.5587216851248571;-2.8979005737257406;-3.3567399995522025;-1.2306749047956247;1.2378712583125091;-0.73509652835064443;-1.217079170549451;5.62684055377653;-2.5538413942156653;-1.4368113242298677;0.18220604751815989;3.0634960584730386;0.97756510814871189;1.7270132010363728;-0.047429140623096888;-0.10458813027483593;1.1548262373602702;0.26918682192955867;1.4654818449130937;4.9813092478657994;-0.068669598186148761;2.5789383119364571;2.1663527656808554;0.25511587778723965;0.63226892391206146;0.21000698901304327;-6.6612449716423514;-1.2477317754998454;-6.666021766839175;-0.91814017767030343;1.5703240016344617;-0.7992585062373988;1.1629681976803825;1.7223617451948305;-1.9102832734400927;-0.66296614278642052;-2.1668304619926899;-1.33273748538781;-1.1037864143869782;-7.2726192282906936;-1.779346220634511;2.4110107613553562;0.10561336649463629;1.9726726848567782;-2.0405327821807395;3.0593525167931559;3.6436870258665053;1.7104564891588245;-2.9829608541991051;0.73323979531737526;4.2116557382280808;-2.4867548892159586;-0.46535977776166887;-3.2010942479455684;-4.202633372971178;3.2856182196308192;-3.8812917400383191;-3.7772460002551651;4.6259552230216539;3.7613843938356473;4.2406873446579638;-4.0384703450395127;-4.0558626109814133;-4.2073782776459083;-4.2701210849987561;4.024265604268459;-6.4234430967948306;-6.4389583135803328;-7.3934592826803982;4.6643096677798592;4.1838514674141001;4.8301067852840252;-4.7953643942290043;2.6303418975184503;-6.0115273390021526;5.1695168299073222;5.4561103370290427;8.1051106447530401;5.6539226173541435;16.837864527816158;-15.461132473029874;-6.4409983947743017;6.1725870514126289;11.233708351869364;-6.6226017921687168;-17.841777508349704;6.7410827574402177;7.1942286045489645;-6.6433099739678276;-8.7286991747165068;-6.9273871801768845;6.9432235703560954;-18.585348259654555;-7.1340954567832631;7.2721420989920711;7.2814639199150957;7.4383131229831312];
IW1_1 = [6.0066533777166216 4.0513353936797687 -1.7176291397283663;1.2164808331686665 4.0005059354234138 -5.9413160083902934;-5.4812583997172322 -0.50639187036547928 -4.9691267522314;-2.3015517300107335 -1.633876184532465 -6.859543036907449;-2.6748734719710163 13.286190323819747 3.4668045951621278;-8.050163620319859 3.9603519200134611 -0.019743725462604958;-5.1872606690818062 -4.8974634008023603 -2.1073360099032792;2.6892889335511483 5.327421500546186 4.4404232906135164;1.1202611349112508 11.124574414769887 17.395675506949683;-6.5869317454989176 -2.9379324296375571 -1.8510361557260191;7.9239066944609045 -5.2552441859450614 4.5072613777365005;2.9942925545947849 5.8288936081889124 -3.9216819804285921;-0.45456763724267363 -4.7298422637861872 -5.7174390356191225;-2.6982355063045813 6.2226654604694112 -3.509060538695695;6.4850824162788561 -6.942221234570173 3.5980222302165559;-1.9422062620574496 8.0540574098843294 4.9746894687956527;2.3295100620621429 -4.9711943493346302 5.8511531659748712;4.9221848728144968 4.8627838107014467 2.7339120242950128;-0.11619168840684498 -4.803007989399835 -5.6674066870872579;-12.608336420216897 13.246580328240965 -7.1967958265495877;-4.3499975238113828 -5.8349266260184143 1.6314930554386924;9.3794919068635725 -9.7458108435006192 6.9047885457089402;-1.4005577612139406 -7.0280675143604183 2.0216754066211928;0.27513319643945955 5.2407164845570913 -4.8754863475269943;-6.4195077974458084 1.4509881787046655 -5.0157170405040974;-1.8601758982810921 -6.0878553775363562 9.5191725333228927;5.7804255397141757 4.7331518582226701 0.3895245852467219;-6.3676967838902803 -4.0889575897481922 4.936793397484025;-8.5166241923074253 -4.1010678488728312 12.651156422184778;5.1279479122366958 -5.670367877696604 -6.0162570702313207;6.886373847444502 4.6654217956366617 0.51247332473157137;-0.21298773082697464 -7.4927025131318601 -6.005909665962883;0.55880634277179231 6.4796205471175536 3.6156124980689217;-4.8123592336834307 2.5091275472775165 2.4128590369718905;-0.53881053544395319 3.9446548165950448 -8.3155190542438184;5.1945294231000725 4.6564031737516407 2.7707319015896523;5.7242733390859204 -0.3048203909410625 -3.397120385499051;5.7852879111720608 3.7446250282647444 3.4295820180806054;3.7966611929551393 4.1590721495115277 4.8528341320743769;-1.2658207761446754 -7.1889281985064173 -1.2740498533762181;-11.855662234993195 -8.3949873832935271 5.7589664831188854;10.669895814723663 6.8147108326144803 -0.020810048370345897;1.1038737286776377 0.86674602827576652 7.8624560544592343;12.88587681547757 5.9256045557224946 3.0748728568525072;-1.6283767938216589 3.9037692476455317 -7.8811379602918432;0.31749177574748527 7.8064938306094298 -7.2817863681996782;10.70984799877958 8.9487722910503873 1.1457836995086415;-9.4968238088354173 3.1235105851142797 -7.7312264936996291;-4.7639939626513321 0.60654317855751849 -6.3482063903106587;8.9135979687875793 -0.54254473838501371 0.13548742953884862;4.7957504294840101 -10.505978797864062 -3.0595334707353676;-4.1858421646464521 8.2492181878280526 1.5197766579918606;9.3345312885612142 -4.0402225380297692 9.6821081184590341;2.5427957861851476 5.6244879207711032 4.3381980557354911;9.5383914543403261 0.60789954364838028 7.1996660469037685;9.8771874617124613 -1.022705529068046 6.8844831945505476;7.6780576286736677 -1.8375672434631858 -3.0342211300369946;-5.4174992088182181 5.8290570775441974 -6.7078949669371593;4.028867518538358 4.1490361804014695 5.5002835830488159;5.6145534975231906 3.0097041401811606 3.9640563689387505;0.08087282371676946 -8.6685086976736034 10.834261327022864;1.8516517983031737 3.1795033263688564 -4.3392028682646897;10.298523936027483 0.42681973443900612 3.3849017228030687;-3.2219279296310126 -6.4241776163793558 -5.1425371562027555;-2.1165301957914973 1.100400035462934 6.0049816406981584;-5.7023955203030994 -3.090640664115178 -4.9700389485849463;-2.5073765497038085 2.3243661819818291 -8.9947999594857997;-9.8669837051345457 8.0007250471097393 -1.4277555366101959;-0.89521614796878157 6.7929658826756354 3.8531432450972511;0.85056583578243194 -2.8228717545099715 10.837097966329337;-5.319958011942596 -6.5079912832648352 9.957515633498744;8.9445644930064976 -9.0528089285631008 11.221203098648061;-9.9182572045991151 -4.3951842549880036 13.726872693641861;-0.50609407645384374 0.50993113570822146 -7.7297087463831362;6.1516388907664297 -3.1979157442200017 9.9342749636599876;7.3011479430400721 8.2767324662892285 -9.3924254172983943;11.741329821828344 4.310523108782613 -6.3890133285327453;4.097134617831065 1.2615401190545386 6.1127228796980173;5.5655433514959762 -2.4532891563521813 -5.0312334118215301;-4.0100187965193017 1.8780453753804407 -9.8901566842726965;4.0864722353852967 4.0343758394356017 -5.171920614274188;10.1303866004461 7.8055406046391242 -8.6658635378108961;-4.4873494900898363 3.349470863481725 5.2760713672010917;0.68124438997531478 0.36265471721694509 -8.183981819230274;0.31177399419678742 11.007439090583562 -6.8166166832021391;0.45159045957592986 5.37038592855746 5.8572928720173865;7.5635673440393383 0.42270527285130927 -5.6093540122084526;-5.720340775911974 -7.1367907779261097 -3.7057184939153052;-3.7129692636492164 -3.8579976183084064 -6.0181695443980994;-7.7833011590213594 0.73918940758107854 -2.0013628460797772;-4.7556109283152495 3.8328593415403462 4.3137511318728725;-3.5303985059664114 -1.3920565469404149 -6.595817778941365;-1.7058155249265183 -17.197089917575223 3.4370786946164422;-3.9931178159761029 2.3238574174034152 -3.4726656453055393;7.7446026890142612 8.2518793940318762 -9.1103916403881211;6.383026659054388 9.2391826160045021 -3.2611682209671113;1.6483716216534019 -5.5292922173049579 -4.7732856115576725;-6.5880092547510296 7.4434463757664791 0.55813226749776756;4.5519344894619866 9.1831125549930395 3.0483550263287165;2.8263550353906184 -3.5932522850693456 4.8663664451362134;3.2333183449327949 5.4864661637214223 -8.6939050905241064;-7.0933744143366946 -5.4969611613266585 -1.0045489739528577;5.4453507606496698 1.591360825778221 -0.20163729510957093;-0.39096330086024123 -1.3530185844905922 11.550989498841124;-6.3771385303478398 2.1664653376538272 4.242365882191617;-0.97129949946559224 -6.3664378685438558 6.2520065041567179;-1.7035137011101575 2.9499881584799064 7.1085816087034486;-4.2621153279996378 -0.48786018732935432 -1.2496534744249688;2.4843195968313974 2.4704239192725135 -6.7402727517981109;-0.35158404249938852 4.6925045247129287 5.6772097411165161;-1.967409147424118 4.7486170314136729 5.231029712286098;4.2943603555457122 0.045932739705049928 -5.3968188764135592;3.6962155810389894 -5.9563420863005545 -2.4732940830106389;1.1189171843470347 5.1520476222116542 -5.5697797792982922;-5.015941945146511 3.3372402928827141 4.3014163693082184;-2.8185184713775744 6.8814621564821365 0.070686367120906674;-6.7375534085270772 -2.8494355834168399 -0.69322867283577105;-3.684515954318083 6.4301581347462484 0.56359102405807138;4.5770609491295611 -4.0947766165410666 -4.5790033783339386;-4.8395283565988212 10.544431397163608 -8.1241450854940407;-9.8967379426521696 2.4853765673444235 -5.0375153285882108;-8.450089760456347 -5.5146875513096401 2.8961613474653474;2.3217334655671347 -6.7181025148828279 2.2830319749048611;7.2410040254979151 1.7766972718117349 -5.1341485032256946;5.565887937662592 -4.1430372750264794 -2.864806162744737;-8.5453873472413306 7.9094757093300991 -0.078128931568867493;7.8107905918328129 4.8339271571335027 3.5429924284960421;-2.7335033584754513 -4.7187467557994394 -5.8714112334750403;4.9393153059485151 -4.6065684489949179 -3.3717936946641629;4.8383173387377196 -5.4036245294407177 -1.5963725494747525;5.0541881449380233 10.450481421179097 -4.4413525725772356;4.5619580135360156 -5.6412163485892561 -1.5870267775052163;6.7481054167509331 1.3860354454285218 19.069251867338163;-11.332927849039136 -5.2761089935271137 -9.7372916868048467;-6.6490293667355838 0.076436205638853338 3.5843316782429318;6.0202930488637962 -4.1984215889371921 -0.23534892467037408;1.1158842333405448 -5.6298179506350143 14.814680392656326;-4.6306703945366143 7.7360677602765477 -5.2594755068233168;-7.848314102124875 -7.728457868710457 -15.282971492475651;8.0937496382204177 -1.3985906270394031 -0.45011715509923589;2.8918797339080609 7.0151302533399074 -0.85190394760218413;-3.885226005759415 4.6379999779124166 4.3230046646232454;-2.4057971589877032 -7.2347308206518139 -7.6187679341539063;-0.51433541521871429 7.3242519903909367 -0.15162107516532974;3.0247440611520795 -6.7781014381956997 -0.41727650740886452;-6.7825448998699533 -1.3798065972319287 -21.12755521836463;-4.4982621440144461 2.7311900301722654 5.2558051879364855;6.5626133359567644 1.6204369907204976 -3.5801506369828693;3.621829767952252 -3.8809288493725269 6.129658016548329;1.8237572216439666 -4.335248676864528 -5.7633474246733432];

% Layer 2
b2 = 0.13864694543729567;
LW2_1 = [0.86800908497472928 0.29584955258662904 -0.070980198551345047 -0.35938529617566412 0.49694722573717465 -2.5875704111516393 -0.78305493697867479 -0.43145737907696358 -0.45701103814459554 -0.54688645567963157 6.1448653045870412 -1.0811129777045441 0.35197458098419204 0.98916712110984539 -1.8158273081900171 3.0199437215780569 -1.1922118092337344 0.83457545353468576 0.20656128863213782 0.6055518207038636 -0.45513091028197566 -1.6677666933779143 0.95199391419394175 -0.28094744830050805 2.6225210183539507 -7.7571157706753393 0.12018198577146225 7.0493793296584446 -6.1421885899818669 -2.0152940210757535 3.0677415641605243 4.828384870706433 0.038792144334368388 4.7655549976305647 -3.3478317492286864 1.1733797201208371 5.1902947957920862 1.1710695739033032 1.3060777882296384 -0.5823690155674307 -5.0548780758369194 -6.5892707268456236 -2.2476912759934926 3.5911444435159114 2.1738852204731125 2.3840488481997508 -4.6353270886962141 -5.8921619978451023 1.9665517619532284 -3.3207728327650652 -4.623727201076786 -1.7401931431622399 -2.5903980393582269 -0.74768496812343443 5.0336898163053014 -8.656570545864902 0.87005318744818849 -4.4707094349621475 2.1696061213102058 -0.90579923406431395 -2.9940099480071929 7.8157070444837453 2.8218251983925788 -4.2921200852951662 -3.8801025229511401 2.1930011563579415 -3.2119632060110042 -1.1904519756392999 -2.4375642015095704 5.5220573942581845 -3.8784191952336253 1.0043206868562287 4.7256626635779257 -1.8346916756397216 2.0930448927427996 -6.3980303580958386 0.89553959574623332 -1.0866889943405298 1.5262764600192773 -1.4444324410112632 3.1087925079723653 -1.3058276195528746 -2.1658044068323945 -2.4757944907730183 -2.4754361174340684 -1.7973870914016212 -1.4036392179334187 -3.4946994790927706 2.4850339718383934 1.8494253750389933 -0.057493294172813084 0.33855614840979587 0.37594880316518919 -6.4270173041226633 4.7346267284308716 0.74764545241791458 0.56933202578822106 -4.3561164042537106 -1.8995548717226773 5.1133842820443629 4.2601506593205949 2.1889097874042363 -6.3808051845523677 4.7253435930380077 1.315521993267202 2.8748793040263045 -2.7062498205653958 7.5841554361321402 1.9233608593080975 1.2045359602782209 0.22594636875549512 -0.2961448946597911 0.6654593283228335 -1.5277273182647917 -1.132775624397419 0.31289536626046927 5.6801230182092093 0.41617348652010838 1.1659426314572565 -5.6636605590788038 1.7477890873052035 -2.6513315148733678 0.93249544145403385 2.8522465210215402 0.75016963303432005 2.1574697895499604 -3.2794438561332142 -8.7768363296006857 0.73352457547171956 -0.52356008089986772 -2.6641862546487634 -0.3927037150430388 -3.451265022521361 -1.0787467210959323 -1.6059061375106163 0.16825332844452914 1.9302689300533638 -5.0158861002695794 -0.50878909197869404 -2.628837051472956 3.1142264330077034 -0.24611116521767898 5.7746699037803326 0.62101312002398945 0.050318434068514148 -2.8949177526010894 -0.1259524489296982 1.267406091368499 -6.2436805277724519 -0.42363292606227598];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = 0.24519677090296;
y1_step1.xoffset = -1.344599216494;

% ===== SIMULATION ========

% Dimensions
Q = size(x1,2); % samples

% Input 1
xp1 = mapminmax_apply(x1,x1_step1);

% Layer 1
a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*xp1);

% Layer 2
a2 = repmat(b2,1,Q) + LW2_1*a1;

% Output 1
y1 = mapminmax_reverse(a2,y1_step1);
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings)
  y = bsxfun(@minus,x,settings.xoffset);
  y = bsxfun(@times,y,settings.gain);
  y = bsxfun(@plus,y,settings.ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n,~)
  a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings)
  x = bsxfun(@minus,y,settings.ymin);
  x = bsxfun(@rdivide,x,settings.gain);
  x = bsxfun(@plus,x,settings.xoffset);
end