
function SH_RSE_config(this_block)

  % Revision History:
  %
  %   09-Apr-2008  (11:40 hours):
  %     Original code was machine generated by Xilinx's System Generator after parsing
  %     D:\Data\Xilinx\sysgen\SSP\ssp_proto\V2_2\SH_RSE.vhd
  %
  %

  this_block.setTopLevelLanguage('VHDL');

  this_block.setEntityName('SH_RSE');

  % System Generator has to assume that your entity  has a combinational feed through; 
  %   if it  doesn't, then comment out the following line:
  this_block.tagAsCombinational;

  this_block.addSimulinkInport('EOS');
  this_block.addSimulinkInport('RESET');
  this_block.addSimulinkInport('Scan');

  this_block.addSimulinkOutport('SNEn');
  this_block.addSimulinkOutport('OVFEn');
  this_block.addSimulinkOutport('S');

  OVFEn_port = this_block.port('OVFEn');
  OVFEn_port.setType('Bool');
  OVFEn_port.useHDLVector(false);
  S_port = this_block.port('S');
  S_port.setType('Bool');
  S_port.useHDLVector(false);
  S_port.setRate(1);
  SNEn_port = this_block.port('SNEn');
  SNEn_port.setType('Bool');
  SNEn_port.useHDLVector(false);

  % -----------------------------
  if (this_block.inputTypesKnown)
    % do input type checking, dynamic output type and generic setup in this code block.

    if (this_block.port('EOS').width ~= 1);
      this_block.setError('Input data type for port "EOS" must have width=1.');
    end

    this_block.port('EOS').useHDLVector(false);

    if (this_block.port('RESET').width ~= 1);
      this_block.setError('Input data type for port "RESET" must have width=1.');
    end

    this_block.port('RESET').useHDLVector(false);

    if (this_block.port('Scan').width ~= 1);
      this_block.setError('Input data type for port "Scan" must have width=1.');
    end

    this_block.port('Scan').useHDLVector(false);

  end  % if(inputTypesKnown)
  % -----------------------------

  % -----------------------------
   if (this_block.inputRatesKnown)
     setup_as_single_rate(this_block,'rse_clk','rse_ce')
   end  % if(inputRatesKnown)
  % -----------------------------

    % (!) Set the inout port rate to be the same as the first input 
    %     rate. Change the following code if this is untrue.
    uniqueInputRates = unique(this_block.getInputRates);


  % Add addtional source files as needed.
  %  |-------------
  %  | Add files in the order in which they should be compiled.
  %  | If two files "a.vhd" and "b.vhd" contain the entities
  %  | entity_a and entity_b, and entity_a contains a
  %  | component of type entity_b, the correct sequence of
  %  | addFile() calls would be:
  %  |    this_block.addFile('b.vhd');
  %  |    this_block.addFile('a.vhd');
  %  |-------------

  %    this_block.addFile('');
  %    this_block.addFile('');
  this_block.addFile('SH_RSE.vhd');

return;


% ------------------------------------------------------------

function setup_as_single_rate(block,clkname,cename) 
  inputRates = block.inputRates; 
  uniqueInputRates = unique(inputRates); 
  if (length(uniqueInputRates)==1 & uniqueInputRates(1)==Inf) 
    block.addError('The inputs to this block cannot all be constant.'); 
    return; 
  end 
  if (uniqueInputRates(end) == Inf) 
     hasConstantInput = true; 
     uniqueInputRates = uniqueInputRates(1:end-1); 
  end 
  if (length(uniqueInputRates) ~= 1) 
    block.addError('The inputs to this block must run at a single rate.'); 
    return; 
  end 
  theInputRate = uniqueInputRates(1); 
  for i = 1:block.numSimulinkOutports 
     block.outport(i).setRate(theInputRate); 
  end 
  block.addClkCEPair(clkname,cename,theInputRate); 
  return; 

% ------------------------------------------------------------

