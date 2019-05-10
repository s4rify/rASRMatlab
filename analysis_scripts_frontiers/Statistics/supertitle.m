function f = supertitle(s,pos)
% SUPERTITLE 	makes a big title over all subplots
%
%	supertitle(S) writes the string S as a title
%	It returns the handle if you want it.
%
%	supertitle(S,pos) lets you specify a position be 0 and 1. Default is .95
%
% 1995,1996 Matteo Carandini
% part of the Matteobox toolbox

% 09/07/01 vb re-implementation annotation because would change axes
% odering.

if nargin < 2, pos = .98; end

f = annotation('textbox',[0 pos 1 .01],'string',s,'edgecolor','none',...
'hori','center', 'interp', 'none', 'fonts', 13, 'fontweight', 'bold');

return;

% currax = gca;
% 
% h = axes('position',[.5 pos 0.1 0.1 ],'xcolor',[0 0 0],'visible','off');
% 
% set(h,'color','none');
% 
% if ~isempty(s)
% 	f = text(0 , 0, s, 'units', 'normalized',...
% 		'verticalalignment','top','horizontalalignment','center' );
% end
% 
% axes(currax);