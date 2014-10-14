function [data,labels] = load_data(data_struct)

switch data_struct.dataset
   
    case 'iris'
        load fisheriris
        data = meas;
        [classes,key,labels] = unique(species);
        
    case 'wine'
        load wine_dataset
        wineInputs = wineInputs';
        [labels,col] = find(wineTargets);
        data = wineInputs;
        
    case 'ion' 
        load ionosphere;
        data = X;
        data(:,[1,2]) = [];
        [~,~,labels] = unique(Y);
        
    case 'gaussian'
        data = [];
        labels = [];
        
        plt_types = {'rp', 'bo','ks', 'g^'};
        if data_struct.plot
            figure;
            hold on;
            grid on;
        end
        
        for c = 1:data_struct.classes
            data_c = mvnrnd(data_struct.MU{c}, data_struct.SIGMA{c},...
                data_struct.samples(c));
            data = [data ; data_c];
            labels = [labels; c*ones(data_struct.samples(c),1)]; 
                if data_struct.plot
                    plot(data_c(:,1), data_c(:,2), plt_types{c})
                end
        end
        

                
    otherwise
        error('Unknown Data!')

end