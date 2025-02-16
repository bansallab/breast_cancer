
###############
# Libraries
library(tidyverse)
source('cycling_functions.R') # loads data and functions
library(RColorBrewer)
library(patchwork)

###############

fit <- treat_cycle.rep(100, 100, 100, 5, c(1000, 1000), pars_treat, pars_veh)

###############

pal <- c(brewer.pal(9, 'Blues')[c(4, 8)], brewer.pal(9, 'Greens')[c(4, 8)])
fit$condition <- ordered(fit$condition, c('LCC1, Vehicle','LCC1, Treatment', 'LCC9, Vehicle', 'LCC9, Treatment'))

p1 <- ggplot(fit, aes(x = t, y = N, group = interaction(rep, pop), color = condition))+
  geom_line(alpha = .1, show.legend = F)+
  scale_color_manual(values = pal[c(1, 3, 2, 4)])+
  theme_minimal()+
  labs(y = 'Cell count', 
       x = 'Time steps',
       color = 'Condition',
       tag = 'A')+
  guides(colour = guide_legend(override.aes = list(alpha = 1)))+
  theme(legend.position = c(0.75, 0.15),
        legend.text=element_text(size=18),
        axis.text=element_text(size=20),
        axis.title=element_text(size=30),
        legend.title=element_text(size = 20),
        strip.text.x = element_text(size = 15),
        plot.tag = element_text(size = 25))+
  ylim(0, 16500)

###############
# Refit assuming strong constant competition
pars_treat$beta.mean = 1
pars_treat$beta.sd = .0001
pars_treat$alpha.mean = 1
pars_treat$alpha.sd = .0001

pars_veh$beta.mean = 1
pars_veh$beta.sd = .0001
pars_veh$alpha.mean = 1
pars_veh$alpha.sd = .0001

fit <- treat_cycle.rep(100, 100, 100, 5, c(1000, 1000), pars_treat, pars_veh)

###########
pal <- c(brewer.pal(9, 'Blues')[c(4, 8)], brewer.pal(9, 'Greens')[c(4, 8)])
fit$condition <- ordered(fit$condition, c('LCC1, Vehicle','LCC1, Treatment', 'LCC9, Vehicle', 'LCC9, Treatment'))

p2 <- ggplot(fit, aes(x = t, y = N, group = interaction(rep, pop), color = condition))+
  geom_line(alpha = .1, show.legend = T)+
  scale_color_manual(values = pal[c(1, 3, 2, 4)])+
  theme_minimal()+
  labs(y = '', 
       x = 'Time steps',
       color = 'Condition',
       tag = 'B')+
  theme(legend.position = c(0.6, 0.5),
        legend.text=element_text(size=20),
        axis.text=element_text(size=20),
        axis.title=element_text(size=30),
        legend.title=element_text(size = 20),
        strip.text.x = element_text(size = 15),
        plot.tag = element_text(size = 25))+
  guides(colour = guide_legend(override.aes = list(alpha=1)))+
  ylim(0, 16500)

###########

# Source again to refresh the parameterization
source('cycling_functions.R') # loads data and functions

fit <- treat_adaptive.rep(nrep = 100, 
                          t_total = 1000, 
                          N_max = 10000, 
                          chunk_size = 50, 
                          y0 = c(1000, 100), 
                          pars_treat= pars_treat,
                          pars_veh = pars_veh)

ggplot(fit, aes(x = t, y = N, group = interaction(rep, pop), color = interaction(treatment, pop)))+
  geom_line(alpha = 1, show.legend = T)+
  scale_color_manual(values = pal[c(1, 3, 2, 4)])+
  theme_minimal()+
  labs(y = '', 
       x = 'Time steps',
       color = 'Condition',
       tag = 'B')+
  theme(legend.position = c(0.6, 0.5),
        legend.text=element_text(size=20),
        axis.text=element_text(size=20),
        axis.title=element_text(size=30),
        legend.title=element_text(size = 20),
        strip.text.x = element_text(size = 15),
        plot.tag = element_text(size = 25))+
  guides(colour = guide_legend(override.aes = list(alpha=1)))+
  ylim(0, 16500)

###########
# Simulate assuming that Resistant is 33% less fit than sensitive
# in the presence of vehicle. All else is unchanged.

#pars_treat$r_s.mean <- pars_veh$r_s.mean * (pars_treat$r_s.mean / pars_veh$r_s.mean)
pars_veh$r_r.mean <- pars_veh$r_s.mean * .5

#pars_treat$K_s.mean <- pars_veh$K_s.mean * (pars_treat$K_s.mean / pars_veh$K_s.mean)
pars_veh$K_r.mean <- pars_veh$K_s.mean * .5

# Refit assuming strong constant competition
pars_treat$beta.mean = 1
pars_treat$beta.sd = .0001
pars_treat$alpha.mean = 1
pars_treat$alpha.sd = .0001

pars_veh$beta.mean = 1
pars_veh$beta.sd = .0001
pars_veh$alpha.mean = 1
pars_veh$alpha.sd = .0001


fit <- treat_adaptive.rep(nrep = 100, 
                          t_total = 1000, 
                          N_max = 10000, 
                          chunk_size = 50, 
                          y0 = c(1000, 100), 
                          pars_treat= pars_treat,
                          pars_veh = pars_veh)

ggplot(fit, aes(x = t, y = N, group = interaction(rep, pop), color = condition))+
  geom_line(alpha = 1, show.legend = T)+
  scale_color_manual(values = pal[c(1, 3, 2, 4)])+
  theme_minimal()+
  labs(y = '', 
       x = 'Time steps',
       color = 'Condition',
       tag = 'B')+
  theme(legend.position = c(0.6, 0.5),
        legend.text=element_text(size=20),
        axis.text=element_text(size=20),
        axis.title=element_text(size=30),
        legend.title=element_text(size = 20),
        strip.text.x = element_text(size = 15),
        plot.tag = element_text(size = 25))+
  guides(colour = guide_legend(override.aes = list(alpha=1)))+
  facet_wrap(~pop)

#ggsave('results/images/figures/fig5.jpeg', p1 | p2, scale = 1, width = 15, height =8)

  
