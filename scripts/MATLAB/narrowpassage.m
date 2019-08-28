function gates = narrowpassage( th , d , c1 , c2 , c3 , c4)



nmax=length(th);
gates=[];

x=d.*cos(th);
y=d.*sin(th);


for n=1:nmax-1
    status=0;
        dd=d(n+1)-d(n);
        D=10;
        if dd > c2
            for n2= n+1:nmax
                D1=sqrt((x(n)-x(n2))^2+(y(n)-y(n2))^2);
                if D1<D
                    D=D1;
                    temp=[n,n2,D];
                    status=1;
                end
            end
        end
        if dd <-c2
            for n2= 1:n-1
                D1=sqrt((x(n+1)-x(n2))^2+(y(n+1)-y(n2))^2);
                if D1<D
                    D=D1;
                    temp=[n+1,n2,D];
                    status=1;
                end
            end

        end
        
        if status==1

            if d(temp(2))<c1 && d(temp(1))<c1
                if abs(th(temp(1))-th(temp(2)))>c3
                    if th(temp(2)) > th(1) + c4
                        if th(temp(2)) < th(nmax) - c4
                            gates=[gates; [x(temp(1)) y(temp(2)) temp(3)]];
                        end
                    end
                end
            end
        end
                   
end

