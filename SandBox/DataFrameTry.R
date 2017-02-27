require(ggplot2)
require(tools)
require(RColorBrewer)

Poly3<-function(x,a,b,c,d){
  a + b*x + c*x^2 + d*x^3
}

ParamsDF<-data.frame(Reads=factor(),
                     a=numeric(),
                     b=numeric(),
                     c=numeric(),
                     d=numeric()
                     )

addTo_DF<-function(FileName){
  SetName<-basename(file_path_sans_ext(FileName))
  SetName<-file_path_sans_ext(SetName)
  SetName<-file_path_sans_ext(SetName)
  SetName<-toString(SetName)
  
  FitData<-read.csv(FileName)
  NewRow<-c(SetName,FitData[15,3],FitData[16,3],FitData[17,3],FitData[18,3])
  ParamsDF<-rbind(ParamsDF,NewRow)
  
  return(ParamsDF)
}