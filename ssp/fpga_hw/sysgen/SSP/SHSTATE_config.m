
function SHSTATE_config(this_block)

  % Revision History:
  %
  %   09-Apr-2008  (11:12 hours):
  %     Original code was machine generated by Xilinx's System Generator after parsing
  %     D:\Data\Xilinx\sysgen\SSP\ssp_proto\V2_2\SHSTATE.vhd
  %
  %

  this_block.setTopLevelLanguage('VHDL');

  this_block.setEntityName('SHSTATE');

  % System Generator has to assume that your entity  has a combinational feed through; 
  %   if it  doesn't, then comment out the following line:
  this_block.tagAsCombinational;

  this_block.addSimulinkInport('S');
  this_block.addSimulinkInport('empty');
  this_block.addSimulinkInport('full');
  this_block.addSimulinkInport('CE');
  this_block.addSimulinkInport('RESET');

  this_block.addSimulinkOutport('Scan');
  this_block.addSimulinkOutport('MUXsel');
  this_block.addSimulinkOutport('REQ');
  this_block.addSimulinkOutport('WEQ');

  MUXsel_port = this_block.port('MUXsel');
  MUXsel_port.setType('UFix_4_0');
  REQ_port = this_block.port('REQ');
  REQ_port.setType('Bool');
  REQ_port.useHDLVector(false);
  Scan_port = this_block.port('Scan');
  Scan_port.setType('Bool');
  Scan_port.useHDLVector(false);
  % Scan_port.setRate(1);
  WEQ_port = this_block.port('WEQ');
  WEQ_port.setType('Bool');
  WEQ_port.useHDLVector(false);

  % -----------------------------
  if (this_block.inputTypesKnown)
    % do input type checking, dynamic output type and generic setup in this code block.

    if (this_block.port('CE').width ~= 3);
      this_block.setError('Input data type for port "CE" must have width=3.');
    end

    if (this_block.port('empty').width ~= 1);
      this_block.setError('Input data type for port "empty" must have width=1.');
    end

    this_block.port('empty').useHDLVector(false);

    if (this_block.port('full').width ~= 1);
      this_block.setError('Input data type for port "full" must have width=1.');
    end

    this_block.port('full').useHDLVector(false);

    if (this_block.port('RESET').width ~= 1);
      this_block.setError('Input data type for port "RESET" must have width=1.');
    end

    this_block.port('RESET').useHDLVector(false);

    if (this_block.port('S').width ~= 1);
      this_block.setError('Input data type for port "S" must have width=1.');
    end

    this_block.port('S').useHDLVector(false);

  end  % if(inputTypesKnown)
  % -----------------------------

  % -----------------------------
   if (this_block.inputRatesKnown)
     setup_as_single_rate(this_block,'sh_clk','sh_ce')
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
  this_block.addFile('SHSTATE.vhd');
  this_block.addFile('SHELL_SHSTATE.vhd');

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

