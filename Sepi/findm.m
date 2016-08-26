function [ peaks, vals ] = findm( signal )
    pind = 1; %peak index
    up = 0;
    avgval = mean(signal);
    for sind = 1:length(signal)-1 %signal index
       if(signal(sind,1) < signal(sind+1,1))
           up = 1;
       end
       if(signal(sind,1) > signal(sind+1,1) && up ~= 0)
           up = 0;
           if(signal(sind,1) > avgval)
               peaks(pind,1) = sind;
               vals(pind,1) = signal(sind, 1);
               pind = pind + 1;
           end
       end
    end
end


