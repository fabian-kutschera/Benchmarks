#!/bin/bash
#SBATCH -J tpv37
#SBATCH -o /hppfs/work/pn49ha/ru64lev2/Benchmarking/output/tpv37/%A_%x.out
#SBATCH -e /hppfs/work/pn49ha/ru64lev2/Benchmarking/output/tpv37/%A_%x.err

#SBATCH --account=pn49ha
#SBATCH --partition=general
#SBATCH --nodes=64
#SBATCH --time=01:00:00

#SBATCH --ntasks-per-node=1
#SBATCH --no-requeue
#SBATCH --ear=off

#SBATCH -D .

#Notification and type
#SBATCH --mail-user=f.kutschera@campus.lmu.de
#SBATCH --mail-type=BEGIN,END,ARRAY_TASKS
#SBATCH --mail-user=f.kutschera@campus.lmu.de

module load slurm_setup 
export LD_LIBRARY_PATH=$HOME/lib:$LD_LIBRARY_PATH

ulimit -Ss 2097152

export MP_SINGLE_THREAD=no
unset KMP_AFFINITY
export OMP_NUM_THREADS=46
export OMP_PLACES="cores(23)"

export XDMFWRITER_ALIGNMENT=8388608
export XDMFWRITER_BLOCK_SIZE=8388608
export SC_CHECKPOINT_ALIGNMENT=8388608

export SEISSOL_CHECKPOINT_ALIGNMENT=8388608
export SEISSOL_CHECKPOINT_DIRECT=1
export ASYNC_MODE=THREAD
export ASYNC_BUFFER_ALIGNMENT=8388608

source /etc/profile.d/modules.sh

echo 'num_nodes:' $SLURM_JOB_NUM_NODES 'ntasks:' $SLURM_NTASKS 'cpus_per_task:' $SLURM_CPUS_PER_TASK
cat material.yaml
cat fault.yaml
ulimit -Ss 2097152

#mpiexec -n $SLURM_NTASKS /hppfs/work/pn49ha/ru64lev2/Benchmarking/v1.1.4/SeisSol/build-release/SeisSol_Release_dskx_4_elastic parameters.par
#mpiexec -n $SLURM_NTASKS /hppfs/work/pn49ha/ru64lev2/Benchmarking/v1.1.4/SeisSol/build-release/SeisSol_Release_dskx_5_elastic parameters.par
#mpiexec -n $SLURM_NTASKS /hppfs/work/pn49ha/ru64lev2/Benchmarking/v1.1.3/SeisSol/build-release/SeisSol_Release_dskx_4_elastic parameters.par
#mpiexec -n $SLURM_NTASKS /hppfs/work/pn49ha/ru64lev2/Benchmarking/SeisSol/build-release/SeisSol_Release_dskx_4_elastic parameters_branch_David.par
mpiexec -n $SLURM_NTASKS /hppfs/work/pn49ha/ru64lev2/Benchmarking/v1.2.0/SeisSol/build-release/SeisSol_Release_dskx_4_elastic parameters_branch_David.par
