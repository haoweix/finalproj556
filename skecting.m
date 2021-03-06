z=rand(3,10,4);
d=rand(5,4);

D=size(d,1);
K=size(z,3);
N=size(z,2);
L=size(z,1);
dflat=reshape(d,[D*K 1]);
zflat=reshape(z(1,:,:),[N*K 1]);
MAXITER=1000;
for t=1:MAXITER
    Ad=zeros(N,N*K);
    for i=1:K
        dpad=[d(:,i)' zeros(1,N-D)];
        Ad(:,(i-1)*N+1:i*N)=toeplitz(dpad,[dpad(1) fliplr(dpad(2:end))]);
    end
    for i=1:L
        zflat=reshape(z(i,:,:),[N*K 1]);
        zflat=lsonecnsrt(Ad,y(i,:),L,zflat);
        z(i,:,:)=zflat;
    end
    Az=zeros(N*L,D*K);
    for j=1:L
        for i=1:K
            ztemp=reshape(z(j,:,i),[1 N]);
            toeptemp=toeplitz(ztemp,[ztemp(1) fliplr(ztemp(2:end))]);
            Az((j-1)*N+1:j*N,(i-1)*D+1:i*D)=toeptemp(:,1:D);
        end
    end
    dflat=reshape(d,[D*K 1]);
    yflat=reshape(d,[N*L 1]);
    dflat=logbarrier(Az,yflat,dflat,2,D);
end

