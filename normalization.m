function imageOutput = normalization(imageData,xcp,ycp,rp,xci,yci,ri)
% imageInput = iris image
% xcp,ycp,rp coordinates of pupil
% xci,yci,ri = coordinates of iris boundaries
% sizeX,sizeY = size of imageOutput
% imageOutput =  iris normalize
% this function has wrong parameter input please swrap x <-> y
for degree = 0:360;
    %r=ri-rp;
    for r=rp:ri;
        %xp = xcp+r*cosd(degree);
        %yp = ycp+r*sind(degree);
        xi = xci+r*cosd(degree);
        yi = yci+r*sind(degree);
        %xp = floor(xp);
        %yp = floor(yp);
        xi = floor(xi);
        yi = floor(yi);
        %if(r>rp)
            %imageOutput((r-rp+1),(degree+1)) = imageInput(xp,yp);
            imageOutput((r-rp+1),(degree+1)) = imageData(xi,yi);
        %end
        %imageOutput1(r,degree) = imageInput(xp,yp);
        %imageOutput2(r,degree) = imageInput(xi,yi);
        %imageInput(xp,yp) = 255;
        %imageInput(xi,yi) = 255;
    end
end
end