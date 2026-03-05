function zscored_value = nanzscore(x)
    zscored_value = (x - nanmean(x))./nanstd(x);
end