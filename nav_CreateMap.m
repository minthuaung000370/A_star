function [figHandle handleMatrix]=nav_CreateMap(mapSize)
    %set the step size
    step=30;
    %Draw the map
    figHandle=figure('MenuBar','none','Position',[400 600 mapSize*step mapSize*step]);
    %set the window position
    tempPos=get(gcf,'Position');
    set(gcf,'Position',[0 0 tempPos(3) tempPos(4)]);
    
    %create empty matrix for handles
    handleMatrix=zeros(mapSize,mapSize);
    
    %plot vertical lines
    for i=0:mapSize
        plot([i i],[0 mapSize],'Color','black');
        hold on;
        plot([0 mapSize],[i i],'Color','black');
        hold on;
    end
    %fill every point as white
    for i=1:mapSize
        for j=1:mapSize
            %plot the point
            tempX=[i-1; i; i;i-1];
            tempY=[j-1;j-1;j;j];
            tempH=fill(tempX,tempY,'w');
            hold on;
            handleMatrix(i,j)=tempH;
        end
    end
    %Set axis
    axis([0 mapSize 0 mapSize]);
    hold on;
end