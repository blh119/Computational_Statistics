
### LAB 19 & 20: BOOTSTRAPPING
#
### Quantiles for Chi sample
#
q.exp1<-function(ns, nq)
{
  df <- double(nq)
  for(k in 1:nq) {
    s <- rexp(ns, 1)
    df[k] <- mean(s) - 1
  }
  return(quantile(df, 1:19/20))
}
#
### Studentized quantiles
#
qstu.exp1<-function(ns, nq)
{
  dfs <- double(nq)
  for(k in 1:nq) {
    s <- rexp(ns, 1)
    dfs[k] <- (mean(s) - 1)/(sqrt(var(s)/ns))
  }
  return(quantile(dfs, 1:19/20))
}

#
###############################################################
# Bootstraps Using Monte Carlo to Estimate Bias and MSE
### CHI8 ###
#
bs.p.exp1<-function(ns, nr, nb, uu)
{
  s <- double(ns)	# S
  ss <- double(ns)	# S*
  pp <- matrix(double(nb * 19), nrow = nb)	# obs'd pk(S) across S's
  for(i in 1:nb) {
    s <- rexp(ns, 1)	# get S  
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
bs.na.exp1<-function(ns, nb, uu)
{
  s <- double(ns)
  pp <- matrix(double(nb * 19), nrow = nb)
  for(i in 1:nb) {
    s <- rexp(ns, 1)  # then use "rexp" 
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
bs.s.exp1<-function(ns, nr, nb, uu)
{
  s <- double(ns)					  # S
  ss <- double(ns)					# S*
  pp <- matrix(double(nb * 19), nrow = nb)	 # obs'd pk(S) across S's
  for(i in 1:nb) {
    s <- rexp(ns, 1)			# get S  
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
bs.w.exp1<-function(ns, nr, nb, uu)
{
  s <- double(ns)	# S
  ss <- double(ns)	# S*
  pp <- matrix(double(nb * 19), nrow = nb)	 # obs'd pk(S) across S's
  for(i in 1:nb) {
    s <- rexp(ns, 1)	# get S  
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

# bsws <- bs.ws.chi8(20,50,100,uks.8)

###############################################################
### PLOTS ###
#
uk.8 <- q.exp1(20,1000)
uks.8 <- qstu.exp1(20,1000)

bsna1 <- bs.na.exp1(20,100,uk.8)      # Normal approx
bsp1 <- bs.p.exp1(20,50,100,uk.8)     # Plain BS
bss1 <- bs.s.exp1(20,50,100,uks.8)    # Studentized BS
bsw1 <- bs.w.exp1(20,50,100,uk.8)     # Wild BS
bsws <- bs.ws.chi8(20,50,100,uks.8)   # Studentized Wild BS

xax<-1:19/20
plot(xax,bsna1[,1], type="o", pch=0, bg=par("bg"), col = "blue",ylim=c(-0.08,0.02),ylab="Bias", cex=.6, main='Bias for EXP1')
lines(xax,bsp1[,1], type="o", pch=1, bg=par("bg"), col = "darkgreen",cex=.6)
lines(xax,bsw1[,1], type="o", pch=2, bg=par("bg"), col = "darkorchid", cex=.6)
lines(xax,bss1[,1], type="o", pch=21, bg=par("bg"), col = "darkorange", cex=.6)
# lines(xax,bsws[,1], type="o", pch=23, bg=par("bg"), col = "red", cex=.6)
legend(.15, .019, legend=c("Normal","Plain","Wild","Stu"),
       col=c("blue", "darkgreen","darkorchid","darkorange"), 
       lty=1, cex=0.6,text.font=1,box.lty=0)

#### EXPECTED SQUARE ERROR ##########
#
xax<-1:19/20
plot(xax,bsna1[,2], type="o", pch=0, bg=par("bg"), col = "blue",ylim=c(0,0.015),ylab="MSE", cex=.6, main='MSE for EXP1')
lines(xax,bsp1[,2], type="o", pch=1, bg=par("bg"), col = "darkgreen",cex=.6)
lines(xax,bsw1[,2], type="o", pch=2, bg=par("bg"), col = "darkorchid", cex=.6)
lines(xax,bss1[,2], type="o", pch=21, bg=par("bg"), col = "darkorange", cex=.6)
#lines(xax,bsws[,2], type="o", pch=23, bg=par("bg"), col = "red", cex=.6)
legend(0.085, 0.014, legend=c("Normal","Plain","Wild","Stu"),
       col=c("blue", "darkgreen","darkorchid","darkorange"),
       lty=1, cex=0.6,text.font=1,box.lty=0)