#!/bin/sh

#  AudioIDPathcer.sh
#
#
#  basic auido layout id ingect.
#
#  Ver 1.0
#
#  Created by Xc233 on 2018/5/25.
#


iaslpath="/usr/bin/iasl"

clear

#get layout id
function ingectid(){
echo "#####################################################"
read -p "请输入你要注入的的声卡layout id (1-99) :" layoutid
cd  ~/Desktop

#generate SSDT-HDEF.aml
cat <<END >SSDT-HDEF.dsl

DefinitionBlock ("", "SSDT", 2, "HDEF", "HDEF", 0x00000000)
{
    Method (_SB.PCI0.HDEF._DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
    {
        If (LNot (Arg2))
        {
        Return (Buffer (One)
        {
            0x03
        })
    }

        Return (Package ()
        {
            "layout-id",
            Buffer ()
            {
            $layoutid, 0x00, 0x00, 0x00
            },

            "hda-gfx",
            Buffer ()
            {
            "onboard-1"
            },

            "PinConfigurations",
            Buffer (Zero){}
            })
    }
}
END
#SSDT-HDEF.dsl->SSDT-HDEF.aml
iasl SSDT-HDEF.dsl

#remove SSDT-HDEF.ds
rm  SSDT-HDEF.dsl

#clean screen
clear

echo "##############################################################################"
echo "##############################################################################"
echo "#################SSDT-HDEF.aml已生成,请放到ACPI/patched文件夹#################"
echo "##############################################################################"
echo "##############################################################################"
}




if [ ! -f "$iaslpath" ];
then
rm -rf ~/iasldown
echo "#####################################################"
echo "iasl不存在,正在下载安装......."
git clone https://github.com/Xc2333/iasldown.git
cd ~/iasldown
unzip iasl.zip
sudo cp ~/iasldown/iasl  /usr/bin
echo "安装完成"
ingectid
else
ingectid
fi
