function [sym_txt] = markerid(sym_id)
        switch sym_id
            case 1
            sym_txt = 'o';
            case 2
            sym_txt = 's';
            case 3
            sym_txt = 'd';
            case 4
            sym_txt = '^';
            case 5
            sym_txt = 'v';
            case 6
            sym_txt = '>';
            case 7
            sym_txt = '<';
            case 8
            sym_txt = 'p';
            case 9
            sym_txt = 'h';
            case 10
            sym_txt = '+';
            case 11
            sym_txt = 'x';
            case 12
            sym_txt = '*';
            case 13
            sym_txt = '.';
        end
end