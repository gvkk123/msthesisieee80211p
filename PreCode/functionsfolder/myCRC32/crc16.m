function [resto] = crc16(h)
    %X^16+X^15+X^2+1
    %gx = [1 1 0 0 0 0 0 0 0 0 0 0 0 1 0 1];
    gx = [1,0,0,0,0,0,1,0,0,1,1,0,0,0,0,0,1,0,0,0,1,1,1,0,1,1,0,1,1,0,1,1,1]';
    
    px = h;
    
    pxr=[px zeros(1,length(gx))];
    
    [c,r]=deconv(pxr,gx);
    
    r=mod(abs(r),2);
    
    resto=r(length(px)+1:end);
    
    resto = resto(2:33);
    
end