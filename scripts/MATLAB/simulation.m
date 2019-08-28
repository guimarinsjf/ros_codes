
function Sensor = VirtualRangefinder3(PoseRobo , Mapa)

switch nargin
    case 2
        if mod(PoseRobo.th,360) > 180, PoseRobo.th = mod(PoseRobo.th,360) - 360; end
    otherwise
        error('A posi��o do rob� no formato de estrutura (structure), exemplo, PoseRobo.x = 0; PoseRobo.y = 0; PoseRobo.th = 0; com [x,y] em mil�metros e [th] em graus. Insira um n�mero de mapa de 1 a 4.')
end

% Posicao informada pela odometria (posui erros)
% Sensor.Position.Pose_Hodometria = PoseRobo;
% Posicao real do robo (que se deseja descobrir
PoseReal.x  = PoseRobo.x-400*cosd(PoseRobo.th);  %+ 20 * randn;
PoseReal.y  = PoseRobo.y-400*sind(PoseRobo.th);  %+ 20 * randn;
PoseReal.th = PoseRobo.th; %+ 1  * randn;
Sensor.Position = PoseReal;

% Declara o mapa do ambiente no formato de retas
if Mapa == 1
    L = [0    0    4680 0;
        0    0    0    3200;
        0    3200 4680 3200;
        4680 0    4680 3200;
        0    2280 920  2280;
        920  2280 920  3200;
        4190 2850 4680 2850;
        4190 2850 4190 3200;
        4030 0    4680 650];
elseif Mapa == 2
    L = [0       0      0       13200
        0       0      14680   0
        0       13200  14680   13200
        14680   13200  14680   0
        1225    1205   0       1205
        1225    1205   1225    0
        2405    13200  0       11196
        11997   11179  11997   13200
        12014   11179  14680   11179
        0       6391   9620    6391
        9620    6391   9620    8004
        11216   6391   14680   6391
        6412    4397   6412    0
        6412    4397   11234   4397
        10002   2783   9204    1604
        9204    1604   10817   1604
        10817   1604   10002   2783
        3203    9618   5614    9618];
    
elseif Mapa == 3
    L = [0       0      0       3600
        0       0      4500   0
        0       3600   4500   3600
        4500    0      4500   3600
        0       900    900      0
        0       2700   900    2700
        900     2700   900    3600
        2700    1800   2700   2700
        2700    2700   4500   2700
        3600    2700   4500   1800];
    
elseif Mapa == 4
    L = [0           0           0        4400
        0           0        3510           0
        0        4400        3510        4400
        3510        4400        3510           0
        0         800         470           0
        3510         800        3040           0
        0         1700        1800        1710
        1800        1710        1800        1000
        2000        4400        2000        3000
        2500        3000        2000        3000
        3300        3000        3500        3000
        1800   0   1800    200];
    
elseif Mapa == 5
    L = [0           0           0        2700
        0           0           1255     0
        1255          0         1255      2700
        1255        2700         0       2700
        920         2210        1255    2210
        920         2210        920     2210
        0           1875       475     2700
        920         2210         920    2700];
elseif Mapa == 6
    L = [0           0           6510     0
        6510        0           6510     7410
        6510      7410           0       7410
        0       7410           0        0
        0       2175          620      2175
        620      2175          620      900
        620      900           3320     900
        3320     900           3320      0
        3320      0            5462      0
        5462      0            6510      810
        5520     5610          6510     5610
        5520     5610          5520     7410
        0       7020          620      7020
        620     7020          620      7410
        4285     3563          3600     4175
        3600     4175          3025     3563
        3025     3563          3600     3045
        3600     3045          4285     3563
        0      2560          665      3215
        665     3215          0        3840];
    
    
% elseif Mapa == 7
%     L  =[           0           0           0        7000
%         200           2900           200        6800
%         0           0        5600           0
%         0        7000        5600        7000
%         5600       7000        5600           0
%         200        1000         700           200
%         700 200 2900 200
%         5400        1300        5000           200
%         5400 1300   5400 4800
%         200        2700        2900        2700
%         200     2700 200 1000
%         200        2900        3100        2900
%         2900        2700       2900        1450
%         3100        2900       3100        1450
%         2900        1450       3100        1450
%         2900        500       3100        500
%         3100    500 3100    200
%         3100 200 5000 200
%         3100        6800        3100        4800
%         3100 6800   200 6800
%         4000        4800        3100        4800
%         5400        4800        4900        4800
%         4900 4800 4900 5000
%         4900 5000   5400 5000
%         5400 5000  5400 6800
%         5400 6800   3300   6800
%         3300 6800 3300  5000
%         3300    5000    4000    5000
%         4000    5000    4000    4800
%         2900           200        2900         500];

elseif Mapa == 7
    L  =[           0           0           0        7000
        200           2900           200        6800
        0           0        5600           0
        0        7000        5600        7000
        5600       7000        5600           0
        200        1000         700           200
        700 200 2900 200
        5400        1300        5000           200
        5400 1300   5400 4800
        200        2700        2900        2700
        200     2700 200 1000
        200        2900        3100        2900
        2900        2700       2900        1450
        3100        2900       3100        1450
        2900        1450       3100        1450
        2900        500       3100        500
        3100    500 3100    200
        3100 200 5000 200
        3100        6800        3100        4800
        3100 6800   200 6800
        4000        4800        3100        4800
        5400 4800  5400 6800
        5400 6800   3300   6800
        3300 6800 3300  5000
        3300    5000    4000    5000
        4000    5000    4000    4800
        2900           200        2900         500];


elseif Mapa == 8
    L  =[0 0 0 4000
        0 4000 4000 4000
        4000 4000 4000 0
        4000 0 0 0
        2000 1000 2000 1500
        2000 1500 2200 1500
        2200 1500 2200 1000
        2200 1000 2000 1000
         2000 2500 2000 3000
        2000 3000 2200 3000
        2200 3000 2200 2500
        2200 2500 2000 2500];

elseif Mapa == 10
L =1000*[ -1.8477,   -4.5110,   -1.8477,   -4.3558
  -1.8477 ,  -4.3558 ,  -3.4583,   -4.3364
 -3.4583  , -4.3364   ,-3.4583  ,  3.4254
 -3.4583  ,  3.4254   ,-2.9538  ,  4.3181
 -2.9538  ,  4.3181   ,-0.6252  ,  4.3181
 -0.6252  ,  4.3181   ,-0.0819  ,  3.4254
 -0.0819  ,  3.4254   ,-0.1013  ,  1.5820
 -0.1013  ,  1.5820   , 0.0540  ,  1.6014
  0.0540 ,   1.6014   , 0.0346  ,  3.3478
  0.0346  ,  3.3478   , 3.4886  ,  3.3672
 3.4886   , 3.3672    ,3.5080   ,-1.6392
 3.5080   ,-1.6392    ,2.5766   ,-1.6198
 2.5766   ,-1.6198    ,2.5766   ,-1.7362
 2.5766   ,-1.7362    ,3.4886   ,-1.7556
 3.4886   ,-1.7556    ,3.5080   ,-4.3558
 3.5080   ,-4.3558    ,0.7137   ,-4.3558
  0.7137  , -4.3558   , 0.7137  , -1.7556
    0.7137,   -1.7556 ,   1.6839,   -1.7556
    1.6839,   -1.7556 ,   1.6839,   -1.6003
    1.6839,   -1.6003 ,   0.7137,   -1.6003
    0.7137,   -1.6003 ,   0.7137,   -0.4361
    0.7137,   -0.4361 ,   0.0540,   -0.3973
    0.0540,   -0.3973 ,   0.0734,    0.6118
    0.0734,    0.6118 ,  -0.0819,    0.6118
   -0.0819,    0.6118 ,  -0.1013,   -0.3973
   -0.1013,   -0.3973 ,  -1.0133,   -0.4167
   -1.0133,   -0.4167 ,  -1.0133,   -0.5525
   -1.0133,   -0.5525 ,   0.5779,   -0.5525
    0.5779,   -0.5525 ,   0.5779,   -4.3364
    0.5779,   -4.3364 ,  -0.9551   ,-4.3364
   -0.9551,   -4.3364 ,  -0.9551  , -4.4916
    4.5946,   -4.5304 ,   4.6140  , -6.5291
    4.6140,   -6.5291 ,  -4.6031  , -6.5097
   -4.6031,   -6.5097 ,  -4.5837 ,  -4.5693];
end

% Limites do mapa
xmin = min([L(:,1) ; L(:,3)]);
xmax = max([L(:,1) ; L(:,3)]);
ymin = min([L(:,2) ; L(:,4)]);
ymax = max([L(:,2) ; L(:,4)]);

Sensor.Map.Lines = L;
Sensor.Map.Limits.xmin = xmin;
Sensor.Map.Limits.xmax = xmax;
Sensor.Map.Limits.ymin = ymin;
Sensor.Map.Limits.ymax = ymax;
% Obtem os landmarks
Sensor.Map.Landmarks.x = [];
Sensor.Map.Landmarks.y = [];
% for i = 1:size(L,1)
%     for j = 1:size(L,1)
%         if ~isequal(i,j)
%             % Pontos que formam as retas do ambiente
%             % Reta 1
%             x1 = L(i,1); y1 = L(i,2);
%             x2 = L(i,3); y2 = L(i,4);
%             % Reta 2
%             x3 = L(j,1); y3 = L(j,2);
%             x4 = L(j,3); y4 = L(j,4);
%             % Denominador
%             den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
%             if ~isequal(den , 0)
%                 % Ponto
%                 Px = ((x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4))/den;
%                 Py = ((x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4))/den;
%                 % Esta no ambiente?
%                 if ((min(x1,x2)-1 <= Px) && (Px <= max(x1,x2)+1) && (min(y1,y2)-1 <= Py) && (Py <= max(y1,y2)+1)) && ...
%                         ((min(x3,x4)-1 <= Px) && (Px <= max(x3,x4)+1) && (min(y3,y4)-1 <= Py) && (Py <= max(y3,y4)+1))
%                     % O ponto eh valido
%                     % Serah que eh repetido?
%                     %dist = min(abs(Px - Sensor.Map.Landmarks.x) + abs(Py - Sensor.Map.Landmarks.y));
%                     dist = min(sqrt((Px - Sensor.Map.Landmarks.x).^2 + (Py - Sensor.Map.Landmarks.y).^2));
%                     if ~isempty(dist)
%                         if dist > 1
%                             % Nao eh repetido
%                             Sensor.Map.Landmarks.x = [Sensor.Map.Landmarks.x ; Px];
%                             Sensor.Map.Landmarks.y = [Sensor.Map.Landmarks.y ; Py];
%                         end
%                     else
%                         % Nao eh repetido
%                         Sensor.Map.Landmarks.x = [Sensor.Map.Landmarks.x ; Px];
%                         Sensor.Map.Landmarks.y = [Sensor.Map.Landmarks.y ; Py];
%                     end
%                 end
%             end
%         end
%     end
% end

% Escolhe o vetor de angulos a serem analisados
THETA = -30:1:30;

% Vetor de distancias finais
D = 5000 * ones(size(THETA));

% Loop de calculo
for k = 1:length(THETA)
    % dist
    dist = D(k);
    
    % Obtem o angulo desejado
    thS = THETA(k);
    
    % Forma o raio de laser
    x1 = PoseReal.x;
    y1 = PoseReal.y;
    x2 = x1 + cosd(PoseReal.th + thS);
    y2 = y1 + sind(PoseReal.th + thS);
    
    for i = 1:size(L,1)
        % Forma a reta do ambiente
        x3 = L(i,1);
        y3 = L(i,2);
        x4 = L(i,3);
        y4 = L(i,4);
        
        % Calcula o denominador para saber se as retas sao paralelas
        den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
        
        if ~isequal(den , 0)
            % Calcula o ponto de interseccao
            Px = ((x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4))/den;
            Py = ((x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4))/den;
            
            % Calcula o angulo entre o robo e o ponto de interseccao
            thP = mod(rad2deg(atan2(Py - PoseReal.y , Px - PoseReal.x)) - PoseReal.th , 360);
            if thP > 180
                thP = thP - 360;
            end
            
            epsilon = 0.01;
            if abs(thS - thP) < epsilon %abs(mod(thS,360) - mod(thP,360)) < epsilon
                % Verifica se o ponto de interseccao pertence ao intervalo
                % do segmento de reta:
                
                if ( (min(x3,x4)-1 <= Px) && (Px <= max(x3,x4)+1) ) && ...
                        ( (min(y3,y4)-1 <= Py) && (Py <= max(y3,y4)+1) )
                    
                    % Calcula a distancia entre o robo e o ponto
                    dist = min(dist , sqrt((PoseReal.x - Px)^2 + (PoseReal.y - Py)^2));
                end
            end
        end
    end
    D(k) = dist + 10 * randn;
    if D(k) > 5000
        D(k)=5000;
    end
end



% Plot
Rot = [cosd(PoseReal.th) -sind(PoseReal.th)
    sind(PoseReal.th)  cosd(PoseReal.th)];

% Corpo do robo
prop = 260;
% Corpo do robo
base=Rot *[400 400 -400 -400;
    300 -300 -300 300];

lws=Rot *[350 450 450 350;
    310 310 350 350];

rws=Rot *[350 450 450 350;
    -310 -310 -350 -350];

lwb=Rot *[200 200 -400 -400;
    330 400 400 330];

rwb=Rot *[200 200 -400 -400;
    -330 -400 -400 -330];

leg=Rot *[325 0 0 325;
    225 225 -225 -225];

larm= Rot *[ -100 -100 300 300;
    275 200 200 275];

rarm= Rot *[ -100 -100 300 300;
    -275 -200 -200 -275];


armor=Rot *[0 0 -200 -400 -400 -200;
    250 -250 -300 -250 250 300];

chair=Rot *[-400 -500 -500 -400;
    -310 -310 310 310];

cam=Rot *[-420 -470 -470 -420;
    -110 -110 110 110];

head=Rot *[-50 -100 -200 -300 -350 -300 -200 -100;
    0 100 150 100 0 -100 -150 -100];




plot([L(1,1) L(1,3)] , [L(1,2) L(1,4)] , 'k' , 'linewidth' , 2)
axis equal; grid on; box on;
xlabel('x [mm]'); ylabel('y [mm]'); hold on;

% Paredes
for i = 2:size(L,1)
    plot([L(i,1) L(i,3)] , [L(i,2) L(i,4)] , 'k' , 'linewidth' , 2)
end


% Lasers
for k = 1:length(D)
    Px(k) = PoseReal.x + D(k) * cosd(PoseReal.th + THETA(k));
    Py(k) = PoseReal.y + D(k) * sind(PoseReal.th + THETA(k));
    
    plot(Px(k) , Py(k) , '.b' , 'linewidth' , 3 , 'markersize' , 10)
    plot([PoseReal.x Px(k)] , [PoseReal.y Py(k)] , 'color' , [171 195 240]/255)
end


Sensor.Rangefinder.Distances = D;
Sensor.Rangefinder.Angles = THETA;
Sensor.Rangefinder.Points.x = Px;
Sensor.Rangefinder.Points.y = Py;

% Robo
% Robo
PoseReal=PoseRobo;
fill(PoseReal.x +base(1,:) ,PoseReal.y + base(2,:) , [0.7 0.7 0.7])
fill(PoseReal.x +lws(1,:) , PoseReal.y +lws(2,:) , [0.1 0.1 0.1])
fill(PoseReal.x +rws(1,:) , PoseReal.y+rws(2,:) , [0.1 0.1 0.1])
fill(PoseReal.x +lwb(1,:) , PoseReal.y+lwb(2,:) , [0.1 0.1 0.1])
fill(PoseReal.x +rwb(1,:) , PoseReal.y+rwb(2,:) , [0.1 0.1 0.1])
fill(PoseReal.x +leg(1,:) , PoseReal.y+leg(2,:) , [0 0 0.3])
fill(PoseReal.x +larm(1,:) , PoseReal.y+larm(2,:) ,  [0.5 0.25 0])
fill(PoseReal.x +rarm(1,:) , PoseReal.y+rarm(2,:) ,  [0.5 0.25 0])
fill(PoseReal.x +armor(1,:) , PoseReal.y+armor(2,:) , [0 0.6 0])
fill(PoseReal.x +chair(1,:) , PoseReal.y+chair(2,:) , [0.5 0.5 0.5])
fill(PoseReal.x +head(1,:) , PoseReal.y+head(2,:) , [0.5 0.255 0])
fill(PoseReal.x +cam(1,:) , PoseReal.y+cam(2,:) , [0.1 0.1 0.1])
hold off
axis([xmin - prop xmax + prop ymin - prop ymax + prop])
plotxmin = min(xmin - 0.05*(xmax-xmin) , PoseReal.x - 2*prop - 0.1*(xmax-xmin));
plotxmax = max(xmax + 0.05*(xmax-xmin) , PoseReal.x + 2*prop + 0.1*(xmax-xmin));
plotymin = min(ymin - 0.05*(ymax-ymin) , PoseReal.y - 2*prop - 0.1*(ymax-ymin));
plotymax = max(ymax + 0.05*(ymax-ymin) , PoseReal.y + 2*prop + 0.1*(ymax-ymin));
axis([plotxmin plotxmax plotymin plotymax]);
title(sprintf('Robo_x = %.2f mm, Robo_y = %.2f mm, Robo_{th} = %.2f deg\nMapa = %i' , PoseReal.x , PoseReal.y , PoseReal.th , Mapa))


end

% elseif Mapa == 4
%     L = [0           0           0        4400
%                     0           0        3510           0
%                     0        4400        3510        4400
%                  3510        4400        3510           0
%                     0         800         470           0
%                  3510         800        3040           0
%                    0         1700        1800        1710
%                  1800        1710        1800         810
%                  2700        4400        2700        3500
%                  2700        3500        3500        3500
%                  1800   0   1800    200];