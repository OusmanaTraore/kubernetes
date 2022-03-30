# var_name_diese_in="            # - name: CALICO_IPV4POOL_CIDR"
192.358.125.65 k8smaster 
$IP_test k8smaster 
- var_value_diese_in=" value: \"192.168.0.0/16\""
var_value_diese_out="value:\"192.168.0.0/16\""
sed -i -e '1a  IP master k8str ' test_calico.sh 
sed -i -e '7 s/ //g' test_calico.sh
sed 's/ \{1,\}/ /g'IP

ip=192.168.46.125
# #sed -i  's/$var_name_diese_in/$var_name_diese_out/g' calico.yml 
# `sed -i  's/            # - name: CALICO_IPV4POOL_CIDR/             - name: CALICO_IPV4POOL_CIDR/g' calico.yml` 
# sed -i  's/$var_value_diese_in/$var_value_diese_out/g' calico.yml 
# #sed -i  's/$var_value_diese_in/$var_value_diese_out/g' calico.yml 
# IP_ENS=$(ip a | cut -d " " -f 6 | grep ^e | cut -d "/" -f 1)
# IP_NUM=$(ip a | cut -d " " -f 6 | grep  1|2 | cut -d "/" -f 1)
IP(){
    IP_num=$(ip a | cut -d " " -f 6 | grep  1 | cut -d "/" -f 1)
    if [ $IP_num -ne 0 ]; then
        case $IP_num in
        echo "$IP_num" 
      ;;
        esac
    else
    echo "'$IP_num' is not a valid pattern"
    echo " adresse : $IP_num"
}
echo "$IP"

apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: 1.19.1
controlPlaneEndpoint: \"k8 smaster:6443\"
networking:
  podSubnet: 192.168.0.0/16
