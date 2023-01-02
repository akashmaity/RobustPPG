function e = estimate_strength(rho)
    cam = [0.38, 0.415, 0.45];
    RPPG = [0.1557    0.9848    0.6863];
    e = rho'.*cam.*RPPG;
    e = e./sqrt(sum(e.^2));
end
