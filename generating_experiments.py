'''
Last Modified: 17-3-2015
Sebastiaan Greeven 

Based on code from jhkwakkel <j.h.kwakkel (at) tudelft (dot) nl>
'''
 
import os
from collections import defaultdict
 
import numpy as np
import jpype
  
from connectors.netlogo import NetLogoModelStructureInterface
from expWorkbench import ParameterUncertainty, CategoricalUncertainty, Outcome,\
                         ModelEnsemble, ema_logging, save_results, warning,\
                         debug
 
  
class EVO(NetLogoModelStructureInterface):
    model_file = r"/ModelSebastiaanGreeven.nlogo"
      
    run_length = 100
      
    uncertainties = [
                    ParameterUncertainty((1.01,1.03), 'ExpFactor'),
                    ParameterUncertainty((0.8,1.2), 'ImpactFactor'),
                     ParameterUncertainty((0,50), 'TimeHorizonGov1'),
                     ParameterUncertainty((0,50), 'TimeHorizonGov2'),
                     ParameterUncertainty((0,50), 'TimeHorizonGov3'),
                     ParameterUncertainty((0,50), 'TimeHorizonGov4'),
                     ParameterUncertainty((0,50), 'TimeHorizonGov5'),
                     ParameterUncertainty((0,50), 'TimeHorizonInd1'),
                     ParameterUncertainty((0,50), 'TimeHorizonInd2'),
                     ParameterUncertainty((0,50), 'TimeHorizonInd3'),
                     ParameterUncertainty((0,50), 'TimeHorizonInd4'),
                     ParameterUncertainty((0,50), 'TimeHorizonInd5'),
                     ParameterUncertainty((0,1), 'DemocraticValue1'),
                     ParameterUncertainty((0,1), 'DemocraticValue2'),
                     ParameterUncertainty((0,1), 'DemocraticValue3'),
                     ParameterUncertainty((0,1), 'DemocraticValue4'),
                     ParameterUncertainty((0,1), 'DemocraticValue5'),
                     ParameterUncertainty((0,20), 'SDTimeHorizonDistribution'),
                     ParameterUncertainty((0.2,1), 'MitigationEnforcementFactor'),
                     ParameterUncertainty((0.5,1), 'EffectInternationalPolicyOnIndividuals'),
                     ParameterUncertainty((0.5,1), 'EffectInternationalPolicyOnNationalPolicy'),  
                     ParameterUncertainty((0.01,0.1), 'BaseChanceOfClimateDisaster'),
                     ParameterUncertainty((0,1), 'EffectOfClimateChangeOnClimateDisasters'),
                     ParameterUncertainty((0,0.30), 'InitialSeverityOfClimateDisaster'),
                     ParameterUncertainty((0,0.30), 'PredictionError'),
                     CategoricalUncertainty(('1','3','5'), 'EmissionMemory'),
                     CategoricalUncertainty(('5','10','15'), 'YearsBetweenInternationalNegotiations'),
                     CategoricalUncertainty(('"Cooperative"','"Prisoners"'), 'GameTheory'),
                     CategoricalUncertainty(('1','3','5'), 'ClimateDisasterMemory'),
                     CategoricalUncertainty(('True','False'), 'ClimateDisasterIncreaseMitigation')
                     ]
      
    outcomes = [Outcome('CumulativeGHGreduction', time=True),
                Outcome('AnnualGHGreduction', time=True),
                Outcome('TotalAgreementEffect', time=True),
                Outcome('BottomUpMitigationRatio', time=True),
                Outcome('TotalClimateDisasterEffect', time=True)                
                ]
    
    nr_replications = 100
    
    
    def __init__(self, working_directory, name, defaults={}):
        super(EVO, self).__init__(working_directory, name)
        
        self.oois = self.outcomes[:]
        
        temp_outcomes = []
        for outcome in self.outcomes:
            temp_outcomes.append(Outcome(outcome.name+'_mean', time=True))
            temp_outcomes.append(Outcome(outcome.name+'_std', time=True))
        self.outcomes = temp_outcomes
        
        self.defaults = defaults
        
        unc_to_remove = self.defaults.keys()
        self.uncertainties = [unc for unc in self.uncertainties if unc.name not in unc_to_remove]
        
    
    def run_model(self, case):
        
        for key, value in self.defaults.items():
            case[key] = value
        
        replications = defaultdict(list)
        
        for i in range(self.nr_replications):
            ema_logging.debug('running replication {}'.format(i))
            self._run_case(case)
 
            for key, value in self.output.items():
                replications[key].append(value)
        
        for key, value in replications.items():
            data = np.asarray(value)
            self.output[key+'_mean'] = np.mean(data, axis=0)
            self.output[key+'_std'] = np.std(data, axis=0)    
            
    def _run_case(self, case):
        """
        Method for running an instantiated model structure. 
        
        This method should always be implemented.
        
        :param case: keyword arguments for running the model. The case is a 
                     dict with the names of the uncertainties as key, and
                     the values to which to set these uncertainties. 
        
        .. note:: This method should always be implemented.
        
        """
        for key, value in case.iteritems():
            try:
                self.netlogo.command(self.command_format.format(key, value))
            except jpype.JavaException as e:
                warning('variable {0} throws exception: {}'.format((key,
                                                                    str(e))))
            
        debug("model parameters set successfully")
          
        # finish setup and invoke run
        self.netlogo.command("setup")
        
        time_commands = []
        end_commands = []
        fns = {}
        for outcome in self.oois:
            name = outcome.name
            
            fn = r'{0}{3}{1}{2}'.format(self.working_directory,
                           name,
                           ".txt",
                           os.sep)
            fns[name] = fn
            fn = '"{}"'.format(fn)
            fn = fn.replace(os.sep, '/')
            
            if self.netlogo.report('is-agentset? {}'.format(name)):
                # if name is name of an agentset, we
                # assume that we should count the total number of agents
                nc = r'{2} {0} {3} {4} {1}'.format(fn,
                                                   name,
                                                   "file-open",
                                                   'file-write',
                                                   'count')
            else:
                # it is not an agentset, so assume that it is 
                # a reporter / global variable
                
                nc = r'{2} {0} {3} {1}'.format(fn,
                                               name,
                                               "file-open",
                                               'file-write')
            if outcome.time:
                time_commands.append(nc)
            else:
                end_commands.append(nc)
                
 
        c_start = "repeat {} [".format(self.run_length)
        c_close = "go ]"
        c_middle = " ".join(time_commands)
        c_end = " ".join(end_commands)
        command = " ".join((c_start, c_middle, c_close))
        debug(command)
        self.netlogo.command(command)
        
        # after the last go, we have not done a write for the outcomes
        # so we do that now
        self.netlogo.command(c_middle)
        
        # we also need to save the non time series outcomes
        self.netlogo.command(c_end)
        
        self.netlogo.command("file-close-all")
        self._handle_outcomes(fns)
        
    
if __name__ == "__main__":
    #turn on logging
    ema_logging.log_to_stderr(ema_logging.INFO)
      
      
#     defaults = {'TimeHorizonGov1':25,
#                 'TimeHorizonGov2':25,
#                 'TimeHorizonGov3':25,
#                 'TimeHorizonGov4':25,
#                 'TimeHorizonGov5':25,
#                 'TimeHorizonInd1':25,
#                 'TimeHorizonInd2':25,
#                 'TimeHorizonInd3':25,
#                 'TimeHorizonInd4':25,
#                 'TimeHorizonInd5':25}
#     msi1 = EVO(r"./models", 'shortTimeHorizon', defaults=defaults)
#     
#     defaults = {'TimeHorizonGov1':50,
#                 'TimeHorizonGov2':50,
#                 'TimeHorizonGov3':50,
#                 'TimeHorizonGov4':50,
#                 'TimeHorizonGov5':50,
#                 'TimeHorizonInd1':50,
#                 'TimeHorizonInd2':50,
#                 'TimeHorizonInd3':50,
#                 'TimeHorizonInd4':50,
#                 'TimeHorizonInd5':50}
#     msi2 = EVO(r"./models", 'longTimeHorizon', defaults=defaults)

    msi1 = EVO('./models', 'full')
     
    #instantiate an ensemble
    ensemble = ModelEnsemble()
      
    #set the model on the ensemble
    ensemble.add_model_structure(msi1)
#     ensemble.add_model_structure(msi2)
        
    ensemble.parallel = True
    ensemble.processes = 36
    
    #perform experiments
    nr_experiments = 1000
    results = ensemble.perform_experiments(nr_experiments, 
                                           reporting_interval=100)
    
    fn = r'.\data\full {} exp {} rep.tar.gz'.format(nr_experiments, 
                                                    msi1.nr_replications)
    save_results(results, fn)