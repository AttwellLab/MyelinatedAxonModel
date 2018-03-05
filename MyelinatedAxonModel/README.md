# Myelinated Axon Model

Simulation of the myelinated axon (by Lee Cossell and David Attwell (https://www.ucl.ac.uk/biosciences/departments/npp/people/da)).

## Getting Started

### Prerequisites

To run the model you will need MATLAB. This model and the associated GUI have been tried using the following combinations:

* MATLAB R2013b running on Windows 7   
* MATLAB R2016a running on OSX El Capitan   

### Installing

Clone or copy the directory to any location. Add the directory to the MATLAB path, or, at the MATLAB command prompt run:

```
>>Setup()
```

which will add the directory to the user's MATLAB path (after asking) and open the GUI.

## Examples

In order to replicate the values of [Arancibia-Carcamo et al. (2017)](https://elifesciences.org/articles/23329) run:

```
>>Carcamo2017Cortex()  		% conduction velocity values for cortical axon
>>Carcamo2017OpticNerve() 	% conduction velocity values for optic nerve axon
```

which are in the Examples directory. There is more example code in that directory which will replicate other uses of the model (in [Bakiri et al. (2011)](http://onlinelibrary.wiley.com/doi/10.1113/jphysiol.2010.201376/abstract) and [Ford et al. (2015)](https://www.nature.com/articles/ncomms9073)). See the [Documentation](Documentation) for more details.

## Authors

* Lee Cossell  
	Sainsbury Wellcome Centre for Neural Circuits and Behaviour, University College London
* David Attwell  
	Department for Neurophysiology, Physiology and Pharmacology, University College London

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgements

Funded by the Wellcome Trust


