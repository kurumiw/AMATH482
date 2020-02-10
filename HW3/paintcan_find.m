function [store_xind, store_yind] = paintcan_find(vidframe, filter, tol, method)

 if ~exist('method','var')
     method = 'y_min_pos';
 end
    numFrames = size(vidframe, 4);


    for k = 1 : numFrames
        mov(k).cdata = vidframe(:,:,:,k);
        mov(k).colormap = [];
    end


    % Tracking the paintcan motion
    for j=1:numFrames
       X = frame2im(mov(j));
       I = rgb2gray(X);
       I = I.*uint8(filter);

       %figure(1)
       %imshow(I);
       %hold on;
       [y,x] = find(I>=(max(max(I)))-tol);

       if strcmp(method, 'y_min_pos') == true
            [min_y, min_y_ind] = min(y);
            %plot(x(min_y_ind), y(min_y_ind), 'ro', 'MarkerSize', 5, 'MarkerFaceColor', 'r')

            store_yind(j) = y(min_y_ind);
            store_xind(j) = x(min_y_ind);

       else if strcmp(method, 'average') == true
            %plot(mean(x), mean(y), 'ro', 'MarkerSize', 5, 'MarkerFaceColor', 'r')
            store_xind(j) = mean(x);
            store_yind(j) = mean(y);
           end

       end
        %drawnow
    end

end
