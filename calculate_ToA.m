   function toa_seconds = calculate_ToA(sf, payload_bytes, bandwidth_hz, coding_rate_den)
       % Calculates Time-on-Air for a LoRa packet.
       % Inputs:
       %   sf: Spreading Factor (7 to 12)
       %   payload_bytes: Payload size in bytes
       %   bandwidth_hz: Bandwidth in Hz (e.g., 125000 for 125kHz)
       %   coding_rate_den: Denominator of the coding rate (e.g., 5 for CR 4/5)
       %                      The numerator is assumed to be 4.

       % LoRaWAN Parameters (can be adjusted if needed)
       preamble_symbols = 8;
       has_explicit_header = true; % Typically true
       has_crc = true;             % Typically true
       low_data_rate_optimize = (sf >= 11); % For SF11 and SF12 with 125kHz BW

       % Symbol Time
       ts_seconds = (2^sf) / bandwidth_hz;

       % Number of symbols in preamble
       n_sym_preamble = preamble_symbols + 4.25;

       % Number of symbols in payload
       % PL = payload_bytes
       % SF = sf
       % H = 1 if header is present (explicit header), 0 if not (implicit)
       % DE = 1 if low_data_rate_optimize is true, 0 if not
       % CR_num = 4 (coding rate numerator)
       % CR_den = coding_rate_den
       h_val = 0;
       if has_explicit_header
           h_val = 1;
       end
       de_val = 0;
       if low_data_rate_optimize
           de_val = 1;
       end

       % Number of payload symbols calculation from Semtech datasheet/LoRaWAN spec
       % This is the complex part:
       % n_sym_payload = 8 + max(ceil(((8*PL - 4*SF + 28 + 16*CRC - 20*H) / (4*(SF - 2*DE)))) * (CR_den/CR_num_effective_for_calc), 0)
       % where CRC is 1 if CRC is present, 0 if not.
       % For CR 4/5, 4/6, 4/7, 4/8, the effective CR for calculation is (CR_den / 4)
       % Let's use a slightly simplified but common representation for the term in ceil:
       % bits_to_encode = 8*payload_bytes - 4*sf + 28 + 16*(has_crc==1) - 20*(has_explicit_header==1);
       % symbols_needed_for_payload = ceil(bits_to_encode / (4*(sf - 2*low_data_rate_optimize)));
       % n_sym_payload = 8 + max(symbols_needed_for_payload * (coding_rate_den / 4) , 0);

       % Simpler formula often used (from online calculators, check against official spec if critical):
       payload_symb_nb = 8 + max(ceil((8*payload_bytes - 4*sf + 28 + 16*(has_crc==1) - 20*h_val) / (4*(sf - 2*de_val))) * (coding_rate_den), 0);
       % The coding_rate_den in the formula above usually refers to the effective coding rate factor (e.g., 4/5 -> 1.25, 4/8 -> 2)
       % Let's use the structure from common libraries:
       % Effective symbols for payload part
       numerator = 8*payload_bytes - 4*sf + 2*(has_explicit_header==1)*10 + 2*(has_crc==1)*8; % 20 if header, 16 if CRC
       denominator = 4*(sf - 2*low_data_rate_optimize);
       if denominator == 0
           toa_seconds = NaN; % Should not happen for valid SFs
           return;
       end
       n_sym_payload_data = ceil(max(numerator,0) / denominator) * (coding_rate_den); % CR is effectively (4+k)/4 where k is 1 to 4 for CR 4/5 to 4/8

       % Total symbols
       total_symbols = n_sym_preamble + n_sym_payload_data;
       % total_symbols = n_sym_preamble + payload_symb_nb; % Using the simpler formula's output

       toa_seconds = total_symbols * ts_seconds;
   end
  