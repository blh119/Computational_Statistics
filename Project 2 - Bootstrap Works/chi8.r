
### LAB 19 & 20: BOOTSTRAPPING
#
### Quantiles for Chi sample
#
q.chi8<-function(ns, nq)
{
  df <- double(nq)
  for(k in 1:nq) {
    s <- rchisq(ns, 8)
    df[k] <- mean(s) - 8
  }
  return(quantile(df, 1:19/20))
}
#
### Studentized quantiles
#
qstu.chi8<-function(ns, nq)
{
  dfs <- double(nq)
  for(k in 1:nq) {
    s <- rchisq(ns, 8)
    dfs[k] <- (mean(s) - 8)/(sqrt(var(s)/ns))
  }
  return(quantile(dfs, 1:19/20))
}


#
###############################################################
# Bootstraps Using Monte Carlo to Estimate Bias and MSE
### CHI8 ###
#
bs.p.chi8<-function(ns, nr, nb, uu)
{
  s <- double(ns)	# S
  ss <- double(ns)	# S*
  pp <- matrix(double(nb * 19), nrow = nb)	# obs'd pk(S) across S's
  for(i in 1:nb) {
    s <- rchisq(ns, 8)	# get S  
    ms <- mean(s)	      # M^
    fr <- rep(0, 19)	  # place for frequencies, replicates 0 19-times.     
    for(j in 1:nr) {
      ss <- sample(s, ns, rep = T)	# get S*
      dm <- mean(ss) - ms	          # get M* - M^
      fr <- fr + (dm < uu)	        # frequencies : WHY WORK?
    }
    pp[i,  ] <- fr/nr	              # pk(S), k = 1:19
  }
  err <- t(pp) - 1:19/20	          # pk(S) - k/20, k = 1:19 
  bias <- apply(err, 1, mean)
  mse <- apply(err^2, 1, mean)
  cbind(bias, mse)
}
#
###############################################################
### NORMAL APPROX ###
#
bs.na.chi8<-function(ns, nb, uu)
{
  s <- double(ns)
  pp <- matrix(double(nb * 19), nrow = nb)
  for(i in 1:nb) {
    s <- rchisq(ns, 8)  # then use "rexp" 
    sd <- sqrt(var(s)/ns)
    pp[i,  ] <- pnorm(uu/sd)
  }
  err <- t(pp) - 1:19/20
  bias <- apply(err, 1, mean)
  mse <- apply(err^2, 1, mean)
  cbind(bias, mse)
}
#
###############################################################
# pch=0,square
# pch=1,circle
# pch=2,triangle point up
# pch=3,plus
# pch=4,cross
# pch=5,diamond
# pch=6,triangle point down
# pch=7,square cross
# pch=8,star
# pch=9,diamond plus
# pch=10,circle plus
# pch=11,triangles up and down
# pch=12,square plus
# pch=13,circle cross
# pch=14,square and triangle down
# pch=15, filled square blue
# pch=16, filled circle blue
# pch=17, filled triangle point up blue
# pch=18, filled diamond blue
# pch=19,solid circle blue
# pch=20,bullet (smaller circle)
# pch=21, filled circle red
# pch=22, filled square red
# pch=23, filled diamond red
# pch=24, filled triangle point up red
# pch=25, filled triangle point do(wn red
###############################################################
### LAB 20 #####
#
###  [A]  #### STUDENT BOOTSTRAP ###
#
bs.s.chi8<-function(ns, nr, nb, uu)
{
  s <- double(ns)					  # S
  ss <- double(ns)					# S*
  pp <- matrix(double(nb * 19), nrow = nb)	 # obs'd pk(S) across S's
  for(i in 1:nb) {
    s <- rchisq(ns, 8)			# get S  
    ms <- mean(s)				    # M^
    fr <- rep(0, 19)				# place for frequencies       
    for(j in 1:nr) {
      ss <- sample(s, ns, rep = T)	# get S*
      sd <- sqrt(var(ss)/ns)		    # get sd*
      dm <- (mean(ss) - ms)/sd	    # stu diff in mean
      fr <- fr + (dm < uu)		      # frequencies
    }
    pp[i,  ] <- fr/nr				    # pk(S), k = 1:19
  }
  err <- t(pp) - 1:19/20				# pk(S) - k/20, k = 1:19 
  bias <- apply(err, 1, mean)   # mean of the columns of err
  mse <- apply(err^2, 1, mean)
  cbind(bias, mse)
}

###############################################################
###  [B]  #### WILD BOOTSTRAP ###
#
bs.w.chi8<-function(ns, nr, nb, uu)
{
  s <- double(ns)	# S
  ss <- double(ns)	# S*
  pp <- matrix(double(nb * 19), nrow = nb)	 # obs'd pk(S) across S's
  for(i in 1:nb) {
    s <- rchisq(ns, 8)	# get S  
    ms <- mean(s)	# M^
    fr <- rep(0, 19)	# place for frequencies       
    for(j in 1:nr) {
      ak <- rpois(ns,1)
      cak <- ak-mean(ak)		# TRICK 2
      dm <- mean(cak*s)	# TRICK 2 :MW
      fr <- fr + (dm < uu)	# freq
    } 
    pp[i,  ] <- fr/nr	# pk(S), k = 1:19
  }
  err <- t(pp) - 1:19/20	# pk(S) - k/20, k = 1:19 
  bias <- apply(err, 1, mean)
  mse <- apply(err^2, 1, mean)
  cbind(bias, mse)
}

###############################################################
###  [C]  #### WILD STUDENTIZED BOOTSTRAP ###
#


###############################################################
### PLOTS ###
#
uk.8 <- q.chi8(20,1000)
uks.8 <- qstu.chi8(20,1000)

uk.8 

bsna8 <- bs.na.chi8(20,100,uk.8)      # Normal approx
bsp8 <- bs.p.chi8(20,50,100,uk.8)     # Plain BS
bss8 <- bs.s.chi8(20,50,100,uks.8)    # Studentized BS
bsw8 <- bs.w.chi8(20,50,100,uk.8)     # Wild BS
#bsws <- bs.ws.chi8(20,50,100,uks.8)   # Studentized Wild BS

xax<-1:19/20
plot(xax,bsna8[,1], type="o", pch=0, bg=par("bg"), col = "blue",ylim=c(-0.04,0.028),ylab="Bias", cex=.6, main='Bias for CHI8')
lines(xax,bsp8[,1], type="o", pch=1, bg=par("bg"), col = "darkgreen",cex=.6)
lines(xax,bsw8[,1], type="o", pch=2, bg=par("bg"), col = "darkorchid", cex=.6)
lines(xax,bss8[,1], type="o", pch=21, bg=par("bg"), col = "darkorange", cex=.6)
#lines(xax,bsws[,1], type="o", pch=23, bg=par("bg"), col = "black", cex=.6)
legend(0.02, .029, legend=c("Normal","Plain","Wild","Stu"),
       col=c("blue", "darkgreen","darkorchid","darkorange"), 
       lty=1, cex=0.6,text.font=1,box.lty=0)

#### EXPECTED SQUARE ERROR ##########
#
xax<-1:19/20
plot(xax,bsna8[,2], type="o", pch=0, bg=par("bg"), col = "blue",ylim=c(0.0005,0.00635),ylab="MSE", cex=.6, main='MSE for CHI8')
lines(xax,bsp8[,2], type="o", pch=1, bg=par("bg"), col = "darkgreen",cex=.6)
lines(xax,bsw8[,2], type="o", pch=2, bg=par("bg"), col = "darkorchid", cex=.6)
lines(xax,bss8[,2], type="o", pch=21, bg=par("bg"), col = "darkorange", cex=.6)
#lines(xax,bsws[,2], type="o", pch=23, bg=par("bg"), col = "black", cex=.6)
legend(0.001, .00575, legend=c("Normal","Plain","Wild","Stu"),
       col=c("blue", "darkgreen","darkorchid","darkorange"), 
       lty=1, cex=0.6,text.font=1,box.lty=0)




chibias <- data.frame(bsp8[,1],bsna8[,1], bss8[,1],
                      bsw8[,1])
names(chibias) <- c('Plain BS Bias', 'Norm BS Bias','Stud BS Bias',
                    'Wild BS Bias')

chibias

var(expbias)

meanchibias <- c(mean(chibias[,1]),
                 mean(chibias[,2]),
                 mean(chibias[,3]),
                 mean(chibias[,4]))
                # mean(chibias[,5]))

medianchibias <- c(median(chibias[,1]),
                   median(chibias[,2]),
                   median(chibias[,3]),
                   median(chibias[,4]))
                   #median(chibias[,5]))


sdchibias <- c(sd(chibias[,1]),
                sd(chibias[,2]),
                sd(chibias[,3]),
                sd(chibias[,4]))
                #sd(chibias[,5]))

deschibias <- data.frame(c('Plain BS Bias', 'Norm BS Bias','Stud BS Bias',
                           'Wild BS Bias'), meanchibias, medianchibias,
                         sdchibias)

names(deschibias) <- c('method', 'mean', 'median', 'standard deviation')


deschibias
