function [] = testeKeyPress(~, x)

teclaAp = x.Character;

if teclaAp == 'w'
    assignin('base','frente',1);
elseif teclaAp == 's'
    assignin('base','tras',1);
elseif teclaAp == 'a'
    assignin('base','esquerda',1);
elseif teclaAp == 'd'
    assignin('base','direita',1);
elseif teclaAp == 'x'
    assignin('base','newlocal',1);
end

end