# > Template for Lambda Cloud Stable Diffusion setup.
# > by Caelan H.

# For all of the following steps open a CLI within a jupyter notebook (My reccomendation)
# Otherwise if you manually ssh into the Lambda server from a local CLI this should work the same.

# 1. Manually Run These 2 Lines in a CLI in the jupyter notebook.
sudo apt install wget git python3 python3-venv
bash <(wget -qO- https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh)

# 2. Let it run the full setup of the webui then once it has launched fully and
# 	you see the local ip 127.0.0.1 or something similar press Ctrl+C to force
# 	the program to close. There is a bunch more stuff todo but since I have made
# 	this script all you have to do is copy and paste one time.

# 3. Run all the remaining lines after completing the instructions above.
#
# > Look for Areas that have >>CONFIGURE<<. In them I tell you how to configure the models
# > that you want to include such as checkpoints, LoRa's, embeddings, controlnet, etc.
#
# After configuring to your liking copy and paste the entire rest of this script into the CLI:
cd ~/stable-diffusion-webui
git checkout "a9eab23"
git reset --hard "a9eab23"
pip install -r requirements.txt
pip install gradio==3.16.2
pip install open_clip_torch clip gdown xformers
pip install scikit-learn==1.2.1
pip install scikit-image==0.20.0

# >>CONFIGURE<< Extensions
#
# I have made a workflow for all the model/extension installations
# For extensions generally they follow the following format:
# 	>> cd ~/stable-diffusion-webui/extensions
# 	>> git clone <repository>
# This works sometimes however if the extension has been updated to work
# post gradio update then you will need to find an old release of
# the extension. To do this you need to cd into the cloned repo then
# checkout the old version with either a version ID or a version hash.
# Add the following to rollback the extension version:
#	>> cd <extension path>
# 	>> git checkout "<version>"
# 	>> git reset --hard "<version>" <- This line may be optional but I recommend including it.
# The extensions I have installed by default are:
# 	> Deforum (TextToVideo), openOutpaint, poseX, ControlNet (openpose), Two-Shot (AKA Latent Couple),
# 	> Image Browser, KitchenTheme (Better UI)
# [Sidenote: You might want to include CivitaiHelper to help find keywords for your embeddings and Lora's.]
#
cd ~/stable-diffusion-webui/extensions
git clone https://github.com/deforum-art/deforum-for-automatic1111-webui.git
cd deforum-for-automatic1111-webui
git checkout "f2db486"
git reset --hard "f2db486"
cd ~/stable-diffusion-webui/extensions
git clone https://github.com/zero01101/openOutpaint-webUI-extension.git
cd openOutpaint-webUI-extension
git checkout "46534e840476dcbea4791d938f711a0d461c1ba"
cd ~/stable-diffusion-webui/extensions
# Note: poseX is buggy it's a 50/50 if it works.
git clone https://github.com/hnmr293/posex.git
cd posex
git checkout "233daf8"
git reset --hard "233daf8"
cd ~/stable-diffusion-webui/extensions
git clone https://github.com/Mikubill/sd-webui-controlnet.git
cd ~/stable-diffusion-webui/extensions
git clone https://github.com/ashen-sensored/stable-diffusion-webui-two-shot.git
cd ~/stable-diffusion-webui/extensions
git clone https://github.com/AlUlkesh/stable-diffusion-webui-images-browser.git
cd ~/stable-diffusion-webui/extensions/stable-diffusion-webui-images-browser
git checkout "62cf141"
git reset --hard "62cf141"
cd ~/stable-diffusion-webui/extensions
git clone https://github.com/canisminor1990/sd-web-ui-kitchen-theme.git
cd ~/stable-diffusion-webui/extensions/sd-web-ui-kitchen-theme
git checkout "9509e3d"
git reset --hard "9509e3d"

# >>CONFIGURE<< ControlNet Models 
#
# Use wget
#
cd ~/stable-diffusion-webui/extensions/sd-webui-controlnet/models
wget https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_openpose-fp16.safetensors


# >>CONFIGURE<< Checkpoints
#
# 	1. Use wget (only if not civitai, ie. huggingface)
# IF using civitai then you need to do two steps.
# 	1. 	>> wget <download URL> (right click the download button on the checkpoint you want and 
#		copy the download URL. It will have a number at the end, after it downloads
#		you will need to rename it back to the model name so you can identify it.)
#	2.  >> mv "<Model #>" <Model Name>.safetensors (DO NOT FORGET TO ADD ".safetensors")
# [Note: you do not need to cd back into the directory each time you install a model.]
#
cd ~/stable-diffusion-webui/models/Stable-diffusion
wget "https://civitai.com/api/download/models/15236"
mv "15236" Deliberate.safetensors
#wget https://huggingface.co/runwayml/stable-diffusion-inpainting/resolve/main/sd-v1-5-inpainting.ckpt

# >>CONFIGURE<< VAE 
#	>> cd ~/stable-diffusion-webui/models/VAE
#	>> wget <VAE URL> (for huggingface VAE's)
#
cd ~/stable-diffusion-webui/models/VAE
wget https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.ckpt

# >>CONFIGURE<< LoRA
#
# Follow my template, this is identical to the process for checkpoints except we
# are in the /Lora directory. [Note: you do not need to cd back into the directory
# each time you install a model.]
#
cd ~/stable-diffusion-webui/models/Lora
wget "https://civitai.com/api/download/models/8840"
mv "8840" DoorToInfinity.safetensors

# >>CONFIGURE<< Embeddings (Textual Inversion)
#
cd ~/stable-diffusion-webui/embeddings
wget "https://civitai.com/api/download/models/8042" # Adventure Diffusion
mv "8042" AdventureDiffusion.pt

# Install some remaining missing packages. Don't ask me why this works trust me, it just does.
cd ~/stable-diffusion-webui
pip install rich

# After everything above has this starts the webui:
python webui.py --share --api --disable-safe-unpickle --enable-insecure-extension-access --no-download-sd-model --no-half-vae --xformers --disable-console-progressbars
