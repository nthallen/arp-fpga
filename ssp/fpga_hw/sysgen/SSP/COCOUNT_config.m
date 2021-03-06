
function COCOUNT_config(this_block)

  % Revision History:
  %
  %   15-Apr-2008  (20:47 hours):
  %     Original code was machine generated by Xilinx's System Generator after parsing
  %     D:\Data\Xilinx\sysgen\SSP\ssp_proto\V2_2\COCOUNT.vhd
  %
  %

  this_block.setTopLevelLanguage('VHDL');

  this_block.setEntityName('COCOUNT');

  % System Generator has to assume that your entity  has a combinational feed through; 
  %   if it  doesn't, then comment out the following line:
  this_block.tagAsCombinational;

  this_block.addSimulinkInport('BOS');
  this_block.addSimulinkInport('PSNZ');
  this_block.addSimulinkInport('empty');
  this_block.addSimulinkInport('TC');
  this_block.addSimulinkInport('RESET');

  this_block.addSimulinkOutport('PreSkip');
  this_block.addSimulinkOutport('LastSkip');
  this_block.addSimulinkOutport('LastScan');

  LastScan_port = this_block.port('LastScan');
  LastScan_port.setType('Bool');
  LastScan_port.useHDLVector(false);
  LastSkip_port = this_block.port('LastSkip');
  LastSkip_port.setType('Bool');
  LastSkip_port.useHDLVector(false);
  PreSkip_port = this_block.port('PreSkip');
  PreSkip_port.setType('Bool');
  PreSkip_port.useHDLVector(false);

  % -----------------------------
  if (this_block.inputTypesKnown)
    % do input type checking, dynamic output type and generic setup in this code block.

    if (this_block.port('BOS').width ~= 1);
      this_block.setError('Input data type for port "BOS" must have width=1.');
    end

    this_block.port('BOS').useHDLVector(false);

    if (this_block.port('empty').width ~= 1);
      this_block.setError('Input data type for port "empty" must have width=1.');
    end

    this_block.port('empty').useHDLVector(false);

    if (this_block.port('PSNZ').width ~= 1);
      this_block.setError('Input data type for port "PSNZ" must have width=1.');
    end

    this_block.port('PSNZ').useHDLVector(false);

    if (this_block.port('RESET').width ~= 1);
      this_block.setError('Input data type for port "RESET" must have width=1.');
    end

    this_block.port('RESET').useHDLVector(false);

    if (this_block.port('TC').width ~= 1);
      this_block.setError('Input data type for port "TC" must have width=1.');
    end

    this_block.port('TC').useHDLVector(false);

  end  % if(inputTypesKnown)
  % -----------------------------

  % -----------------------------
   if (this_block.inputRatesKnown)
     setup_as_single_rate(this_block,'coct_clk','coct_ce')
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
  this_block.addFile('COCOUNT.vhd');

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

