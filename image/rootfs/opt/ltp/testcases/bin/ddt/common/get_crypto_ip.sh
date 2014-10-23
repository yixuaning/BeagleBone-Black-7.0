source "common.sh"                                                      
                                                                        
############################### CLI Params ###################################
                                                                              
############################ USER-DEFINED Params ##############################
# Try to avoid defining values here, instead see if possible                   
# to determine the value dynamically                                           
case $ARCH in                                                        
esac                                                                 
case $DRIVER in                                                      
esac                                                              
case $SOC in                                  
esac              
case $MACHINE in                                                              
am335x-evm|am335x-sk|beaglebone|beaglebone-black|am43xx-epos|am43xx-gpevm)
  CRYPTO_IP='edma';;
*)
  CRYPTO_IP='DMA';;
esac                                                                          

echo $CRYPTO_IP
