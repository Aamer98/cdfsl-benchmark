#!/bin/bash
#SBATCH --mail-user=ar.aamer@gmail.com
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL
#SBATCH --job-name=train_proto
#SBATCH --output=%x-%j.out
#SBATCH --nodes=1
#SBATCH --gres=gpu:2
#SBATCH --ntasks-per-node=32
#SBATCH --mem=127000M
#SBATCH --time=1-00:00
#SBATCH --account=rrg-ebrahimi

nvidia-smi

module load python/3.7
source ~/my_env6/bin/activate

echo "------------------------------------< Data preparation>----------------------------------"
echo "Copying the source code"
date +"%T"
cd $SLURM_TMPDIR
cp -r ~/scratch/cdfsl-benchmark .

echo "Copying the datasets"
date +"%T"
cp -r ~/scratch/CD-FSL_Datasets/* .

echo "Extract to dataset folder"
date +"%T"


# tar -xf $SLURM_TMPDIR/CIFAR100.tar.gz
# tar -xf $SLURM_TMPDIR/CUB_200_2011_FewShot.tar.gz
# tar -xf $SLURM_TMPDIR/CUB_birds_2010.tar.gz
# tar -xf $SLURM_TMPDIR/StanfordCar.tar.gz
# tar -xf $SLURM_TMPDIR/StanfordDog.tar.gz

unzip $SLURM_TMPDIR/EuroSAT.zip
unzip $SLURM_TMPDIR/miniImagenet.zip
#cat $SLURM_TMPDIR/tieredImageNet.tar.gz* | tar -zxf -

echo "----------------------------------< End of data preparation>--------------------------------"
date +"%T"
echo "--------------------------------------------------------------------------------------------"

echo "---------------------------------------<Run the program>------------------------------------"
date +"%T"
cd cdfsl-benchmark


python train.py --dataset miniImageNet --model ResNet10  --method protonet --n_shot 5 --train_aug



cd $SLURM_TMPDIR
cp -r $SLURM_TMPDIR/cdfsl-benchmark/ ~/scratch/cdfsl-benchmark/