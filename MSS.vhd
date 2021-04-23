-- Controlador del sistema de validacion
library ieee;
use ieee.std_logic_1164.all;

entity MSS is

	port(
	-- Entradas
		clk		:	in std_logic;								-- reloj del sistema
		reset		:	in std_logic;								--	reset del sistema
		start		:	in std_logic;								-- Inicia la maquina
		enter		:	in	std_logic;								-- Ingresa el digito
		digit		:	in std_logic_vector(3 downto 0);		--	Digito ingresado de forma secuencial
		timer		:  in	std_logic_vector(1 downto 0);		-- Tiempo de encendido de la senal ok y fin (3s)
	-- Salida
		ok			:	out std_logic;								-- Al finalizar y de ser correcta la secuencia
		fin		:	out std_logic;								-- Al finalizar
		estados	:	out std_logic_vector(3 downto 0)		--	Debug de estados
	);
	
end entity;

architecture rtl of MSS is

	-- Estados
	type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8);
	
	-- Registro de estados
	signal state   : state_type;

begin
	-- Logica para avanzar al siguiente estado
	process (clk, reset)
	begin
		if reset = '1' then
			state <= s0;
		elsif (rising_edge(clk)) then
			case state is
				when s0=>
					if start = '1' then
						state <= s1;
					else
						state <= s0;
					end if;
				when s1=>
					if start = '0' then
						state <= s2;
					else
						state <= s1;
					end if;
				-- Primer Digito
				when s2=>
					if enter = '1' then
						state <= s3;
					else
						state <= s2;
					end if;
				when s3 =>
					if enter = '0' then
						state <= s4;
					else
						state <= s3;
					end if;
				-- Segundo Digito
				when s4=>
					if enter = '1' then
						state <= s5;
					else
						state <= s4;
					end if;
				when s5 =>
					if enter = '0' then
						state <= s6;
					else
						state <= s5;
					end if;
				-- Tercer Digito
				when s6=>
					if enter = '1' then
						state <= s7;
					else
						state <= s6;
					end if;
				when s7 =>
					if enter = '0' then
						state <= s8;
					else
						state <= s7;
					end if;
				-- Resultados
				when s8=>
					if timer = "11" then
						state <= s0;
					else
						state <= s8;
					end if;
			end case;
		end if;
	end process;
	
	-- La salida depende unicamente del estado actual
	process (state,digit)
		-- Variable donde se almacena la secuencia de digitos ingresados
		variable secuence :std_logic_vector(11 downto 0):= "000000000000";
	begin
	
		case state is
			when s0 =>
				ok			<= '0';
				fin		<=	'0';
				estados	<=	"0000";
			when s1 =>
				ok			<= '0';
				fin		<=	'0';
				estados	<=	"0001";
			when s2 =>
				ok			<= '0';
				fin		<=	'0';
				estados	<=	"0010";
			when s3 =>
				ok			<= '0';
				fin		<=	'0';
				estados	<=	"0011";
				secuence (3 downto 0) := digit;	--primeros 4 digitos
			when s4 =>
				ok			<= '0';
				fin		<=	'0';
				estados	<=	"0100";
			when s5 =>
				ok			<= '0';
				fin		<=	'0';
				estados	<=	"0101";
				secuence	(7 downto 4) := digit;	-- Segundo digito
			when s6 =>
				ok			<= '0';
				fin		<=	'0';
				estados	<=	"0110";
			when s7 =>
				ok			<= '0';
				fin		<=	'0';
				estados	<=	"0111";
				secuence (11 downto 8) := digit;	-- Tercer digito
			when s8 =>
				fin		<=	'1';
				estados	<=	"1000";
				if secuence = "001100100001"then -- (3,2,1) = "0011  0010  0001"
					ok			<= '1';
				else
					ok			<= '0';
				end if;
		end case;
	end process;
	
end rtl;
