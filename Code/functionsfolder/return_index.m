function ind = return_index(arr,x)

a = arr-x*ones(size(arr));

if (min(a) >=0)
    %x is smaller than every entry of the array arr
    ind = 1;
elseif (max(a) <=0)
    %x is greater than every entry of the array arr
    ind = max(size(arr));
else
    ind = min(find(a>=0));
end

%x essentially lies between arr(ind-1) and arr(ind)
