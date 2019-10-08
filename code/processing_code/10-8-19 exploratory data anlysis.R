#Univariate analysis
##Use a combination of text/tables/figures to explore and describe your data. 
##You should produce plots or tables or other summary quantities for most of your variables.
##You definitely need to do it for the important variables, i.e. if you have main exposure or outcome variables, those need to be explored. 
##Depending on the total number of variables in your dataset, explore all or some of the others.

#Load libraries 
library(ggplot2)
library(ggthemes)

#Set theme
theme_set(theme_minimal())

#Summary statistics for all data
summary(cleandata$Rainfall)
summary(cleandata$HF183)
summary(cleandata$HumM2)
summary(cleandata$CG01)
summary(cleandata$LeeSg)
summary(cleandata$Dog3)
summary(cleandata$MuBac)
summary(cleandata$Rum2Bac)
summary(cleandata$A_butlzeri_HSP60)
summary(cleandata$Salmonella_spp_InvA)
summary(cleandata$Campylobacter_spp_Van_Dkye)
summary(cleandata$Enterococcus_CCE)
summary(cleandata$total_coliforms)
summary(cleandata$E_coli)
summary(cleandata$Enteroalert)
summary(cleandata$thermotolerant_coliforms)

#Need to group my data by pond
grouped_data <- cleandata %>%
  group_by(Pond)

#Look at temporal trends
clean_water_quality_data %>%
  ggplot() +
  geom_line(aes(x = Date_Sampled, y = HF183, group = 1), data = clean_water_quality_data, stat = "identity") +
  facet_wrap(~ Pond) + 
  labs (x = "Date Sampled",
        y = "Log10 Copies/100mL") + 

  
  
#Line graphs with points, LOD95 
ggplot(data = clean_water_quality_data, aes(x = Date_Sampled, y = HF183)) +
  geom_line() +
  geom_point() +
  labs (x = "Date Sampled",
        y = "Log10 Copies/100mL") +
  facet_wrap(~ Pond) +
  geom_hline(yintercept = 4.92, colour = "blue", linetype = "dotted") +
  theme_bw()

#*LINE GRAPHS*#
#I wanted to make a graph that would show the temporal trends of HF183, HumM2 & A. butzleri to see if there was a relationship (source)
All_Human_Arco <- ggplot(clean_water_quality_data) +
  geom_line(mapping = aes(x = Date_Sampled, y = HF183), color = "dark green") +
  geom_line(mapping = aes(x = Date_Sampled, y = HumM2), color = "purple") +
  geom_line(mapping = aes(x = Date_Sampled, y = A_butzleri_HSP60), color = "navy") +
  geom_point(mapping = aes(x = Date_Sampled, y = A_butzleri_HSP60), color = "navy") +
  geom_point(mapping = aes(x = Date_Sampled, y = HF183), color = "dark green") +
  geom_point(mapping = aes(x = Date_Sampled, y = HumM2), color = "purple") +
  labs (x = "Date Sampled", y = "Log10 Copies/100mL") +
  facet_wrap(~ Pond) +
  geom_hline(yintercept = 3.67, colour = "black", linetype = "dotted") +
  geom_hline(yintercept = 4.14, colour = "black", linetype = "longdash") + 
  geom_hline(yintercept = 3.69, colour = "black", linetype = "twodash") +
  theme_bw()

#One Pond at a time
McCall_Human_Arco <- clean_water_quality_data %>%
  filter(Pond == "McCall_Lake") %>%
  ggplot() +
  geom_line(mapping = aes(x = Date_Sampled, y = HF183), color = "dark green") +
  geom_line(mapping = aes(x = Date_Sampled, y = HumM2), color = "purple") +
  geom_line(mapping = aes(x = Date_Sampled, y = A_butzleri_HSP60), color = "navy") +
  geom_hline(yintercept = 3.67, colour = "black", linetype = "dotted") +
  geom_hline(yintercept = 4.14, colour = "black", linetype = "longdash") + 
  geom_hline(yintercept = 3.69, colour = "black", linetype = "twodash") +
  geom_point(mapping = aes(x = Date_Sampled, y = A_butzleri_HSP60), color = "navy") +
  geom_point(mapping = aes(x = Date_Sampled, y = HF183), color = "dark green") +
  geom_point(mapping = aes(x = Date_Sampled, y = HumM2), color = "purple") +
  labs (x = "Date Sampled", y = "Log10 Copies/100mL") +
  theme_bw()

Country_Hills_Hum_Arco<- clean_water_quality_data %>%
  filter(Pond == "Country_Hills") %>%
  ggplot() +
  geom_line(mapping = aes(x = Date_Sampled, y = HF183), color = "dark green") +
  geom_line(mapping = aes(x = Date_Sampled, y = HumM2), color = "purple") +
  geom_line(mapping = aes(x = Date_Sampled, y = A_butzleri_HSP60), color = "navy") +
  geom_hline(yintercept = 3.67, colour = "black", linetype = "dotted") +
  geom_hline(yintercept = 4.14, colour = "black", linetype = "longdash") + 
  geom_hline(yintercept = 3.69, colour = "black", linetype = "twodash") +
  geom_point(mapping = aes(x = Date_Sampled, y = A_butzleri_HSP60), color = "navy") +
  geom_point(mapping = aes(x = Date_Sampled, y = HF183), color = "dark green") +
  geom_point(mapping = aes(x = Date_Sampled, y = HumM2), color = "purple") +
  labs (x = "Date Sampled", y = "Log10 Copies/100mL") +
  theme_bw()
ggsave(Country_Hills_Hum_Arco, file = "Country_Hills_Hum_Arco.png", path = results)

Inverness_Hum_Arco <- clean_water_quality_data %>%
  filter(Pond == "Inverness") %>%
  ggplot() +
  geom_line(mapping = aes(x = Date_Sampled, y = HF183), color = "dark green") +
  geom_line(mapping = aes(x = Date_Sampled, y = HumM2), color = "purple") +
  geom_line(mapping = aes(x = Date_Sampled, y = A_butzleri_HSP60), color = "navy") +
  geom_hline(yintercept = 3.67, colour = "black", linetype = "dotted") +
  geom_hline(yintercept = 4.14, colour = "black", linetype = "longdash") + 
  geom_hline(yintercept = 3.69, colour = "black", linetype = "twodash") +
  geom_point(mapping = aes(x = Date_Sampled, y = A_butzleri_HSP60), color = "navy") +
  geom_point(mapping = aes(x = Date_Sampled, y = HF183), color = "dark green") +
  geom_point(mapping = aes(x = Date_Sampled, y = HumM2), color = "purple") +
  labs (x = "Date Sampled", y = "Log10 Copies/100mL") +
  theme_bw()
ggsave(Inverness_Hum_Arco, file = "Inverness_Hum_Arco.png")



#One Marker Per Pond
McCall_HF183 <- clean_water_quality_data %>%
  filter(Pond == "McCall_Lake") %>%
  ggplot() +
  geom_line(mapping = aes(x = Date_Sampled, y = HF183), color = "dark green") +
  geom_point(mapping = aes(x = Date_Sampled, y = HF183), color = "dark green") + 
  labs (x = "Date Sampled", y = "Log10 Copies/100mL") +
  geom_hline(yintercept = 3.67, colour = "black", linetype = "dotted") +
  theme_bw()

  
#Box plots
McCall_Boxplot <- clean_water_quality_data %>%
  filter(Pond == "McCall_Lake") %>%
  ggplot() +
  geom_boxplot(mapping = aes(x = HF183, y = Sampling_Site))
McCall_Boxplot



ggplot(data = clean_water_quality_data, aes(x = "", y = HF183)) + 
  geom_boxplot() +
  facet_wrap(~ Pond)

clean_water_quality_data %>%
  filter(Pond == "McCall_Lake") %>%
  ggplot(aes(x = "", y = HF183)) + 
  geom_boxplot() +
  coord_cartesian(ylim = c(0, 6)) +
  facet_wrap(~ Sampling_Site)

#Violin PLots
ggplot(data = clean_water_quality_data, aes(x = "", y = HF183)) + 
  geom_violin() +
  facet_wrap(~ Pond)

clean_water_quality_data %>%
  filter(Pond == "McCall_Lake") %>%
  ggplot(aes(x = "", y = HF183)) + 
  geom_violin() +
  coord_cartesian(ylim = c(0, 6)) +
  facet_wrap(~ Sampling_Site) +
  theme_bw() +
  labs (x = "HF183", y = "Log10 Copies/100mL")

clean_water_quality_data %>%
  filter(Pond == "McCall_Lake") %>%
  ggplot(aes(x = "", y = Enterococcus_CCE)) + 
  geom_violin() +
  geom_boxplot(width=0.1) +
  coord_cartesian(ylim = c(0, 6)) +
  facet_wrap(~ Sampling_Site) +
  theme_bw() +
  labs (x = "Enterococcus", y = "Log10 Copies/100mL")

#Barplots
clean_water_quality_data %>%
  ggplot() +
  geom_bar(aes(x = Shigatoxin_1))


clean_water_quality_data %>%
  ggplot() +
  geom_bar(aes(x = Shigatoxin_1), stat = "count") +
  labs(x = "Shiga Toxin 1", y = "Counts") +
  theme_bw()

clean_water_quality_data %>%
  ggplot() +
  geom_bar(aes(x = Shigatoxin_1), stat = "count", color = "steelblue", fill = "white") +
  labs(x = "Shiga Toxin 1", y = "Counts") +
  theme(panel.background = element_rect(fill = "grey85"))

clean_water_quality_data %>%
  ggplot() +
  geom_bar(aes(x = Shigatoxin_1), stat = "count", fill = "w") +
  labs(x = "Shiga Toxin 1", y = "Counts") +
  theme(panel.background = element_rect(fill = "grey85"))
  
clean_water_quality_data %>%
  ggplot() +
  geom_bar(aes(x = Shigatoxin_1), stat = "count") +
  scale_fill_brewer(palette="Set1")
  
  
  
#Lets look at histograms
ggplot(cleandata, aes(x=HF183)) +
  geom_histogram(binwidth = 1)


clean_water_quality_data %>%
  ggplot() +
  geom_histogram(aes(factor(Shigatoxin_1)), stat = "count") +
  scale_fill_brewer(palette="Set1")
  

