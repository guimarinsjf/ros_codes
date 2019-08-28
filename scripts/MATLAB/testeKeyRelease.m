function [] = testeKeyRelease(~, x)

teclaAp = x.Character;

if teclaAp == 'w'
    assignin('base','frente',0);
elseif teclaAp == 's'
    assignin('base','tras',0);
elseif teclaAp == 'a'
    assignin('base','esquerda',0);
elseif teclaAp == 'd'
    assignin('base','direita',0);
elseif teclaAp == 'x'
    assignin('base','newlocal',0);
end

end