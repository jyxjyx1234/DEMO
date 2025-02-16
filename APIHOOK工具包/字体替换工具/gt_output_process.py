from Lib import *
from HanziReplacer import *
import sys

os.makedirs("release", exist_ok=True)

try:
    orifont = sys.argv[1]
    if orifont == "1":
        orifont = "wenquanyi.ttf"
except:
    raise RuntimeError("输入错误！")
if not os.path.exists(os.path.join(os.getcwd(), orifont)) and orifont != "REPLACE":
    raise RuntimeError("字体不存在！")

h = HanziReplacer()
h.ReadTransAndGetHanzidictFromFolder("gt_output/")
if orifont != "REPLACE":
    h.ChangeFont(orifont, "release/font.ttf", "font")
else:
    h.gen_replace("release\\replace.bin")
files = get_all_files_in_folder("gt_output")
for file in files:
    if file[-4:] == 'json':
        transdata = open_json(file)
        if type(transdata) == dict:
            for i in transdata:
                transdata[i] = replace_halfwidth_with_fullwidth(h.hanzitihuan(transdata[i]))
        elif type(transdata) == list:
            for i in transdata:
                i["message"] = replace_halfwidth_with_fullwidth(h.hanzitihuan(i["message"]))
                if "name" in i:
                    i["name"] = h.hanzitihuan(i["name"])
        outp = "release/" + file
        os.makedirs(os.path.dirname(outp), exist_ok=True)
        save_json("release/" + file, transdata)
    if file[-4:] == '.txt':
        with open(file, 'r', encoding='gbk') as f:
            text = f.read()
        os.makedirs(os.path.dirname("release/" + file), exist_ok=True)
        with open("release/" + file, 'w', encoding='932') as f:
            f.write(h.hanzitihuan(text))
print("完成！请将release文件夹中除去gt_output外的所有文件放入最终发布的补丁中。release/gt_output文件夹中为替换后的译文。")